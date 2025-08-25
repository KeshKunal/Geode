import 'dart:async';
import 'dart:math' show min; // Replace the incorrect import with this
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geode/services/grove_provider.dart';
import 'package:provider/provider.dart';
import 'package:geode/services/blocker_provider.dart';
import 'package:geode/services/blocker_service.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // --- STATE VARIABLES ---

  Timer? _timer;
  Duration _totalDuration = const Duration(minutes: 25);
  Duration _remainingTime = const Duration(minutes: 25);
  bool _isPlaying = false;
  bool _isCompleted = false;

  // --- FRAME ANIMATION VARIABLES ---

  final int _totalFrames = 427;
  int _currentFrame = 0; // holds current frame

  // Audio
  final AudioPlayer _player = AudioPlayer();
  bool _audioPrimed = false;
  bool _isSoundPlaying = false; // NEW

  @override
  void initState() {
    super.initState();
    // Ensure the sound plays once by default (no loop)
    _player.setReleaseMode(ReleaseMode.stop);
    // When the sound finishes naturally, clear the overlay
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isSoundPlaying = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  // --- AUDIO LOGIC ---

  Future<void> _primeAudioEngine() async {
    if (_audioPrimed) return;
    try {
      // Preload the asset so there’s no delay at completion (helps on web too)
      await _player.setSource(AssetSource('audio/bamboo_beat.mp3'));
      _audioPrimed = true;
    } catch (_) {}
  }

  Future<void> _playCompletionSound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/bamboo_beat.mp3'));
      if (mounted) setState(() => _isSoundPlaying = true); // show tap-overlay
    } catch (e) {
      debugPrint('Audio play failed: $e');
    }
  }

  Future<void> _stopSoundIfPlaying() async {
    if (!_isSoundPlaying) return;
    try {
      await _player.stop();
    } catch (_) {}
    if (mounted) setState(() => _isSoundPlaying = false);
  }

  // --- TIMER LOGIC ---

  void _startTimer() {
    Provider.of<BlockerProvider>(context, listen: false).activateBlocker();

    HapticFeedback.lightImpact();
    setState(() {
      _isPlaying = true;
      _isCompleted = false;
      _remainingTime = _totalDuration;
      _currentFrame = 0;
    });

    _primeAudioEngine(); // prepare audio after user gesture

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
          _updateImageFrame();
        });
      } else {
        _timer?.cancel();
        Provider.of<GroveProvider>(context, listen: false)
            .addSession(_totalDuration.inMinutes);
        Provider.of<BlockerProvider>(context, listen: false)
            .deactivateBlocker();

        _playCompletionSound(); // play sound when timer completes

        setState(() {
          _isPlaying = false;
          _isCompleted = true;
          _currentFrame = _totalFrames - 1;
        });
      }
    });
  }

  void _giveUp() {
    Provider.of<BlockerProvider>(context, listen: false).deactivateBlocker();

    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isCompleted = false;
      _remainingTime = _totalDuration;
      _currentFrame = 0;
    });
    _player.stop(); // ensure no leftover sound
  }

  // --- FRAME LOGIC ---

  void _updateImageFrame() {
    // Calculate the progress of the timer (a value from 0.0 to 1.0).
    double progress =
        1.0 - (_remainingTime.inSeconds / _totalDuration.inSeconds);
    _currentFrame = (progress * (_totalFrames - 1)).floor();
  }

  // --- HELPER METHODS ---

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    double progress = _isPlaying
        ? 1.0 - (_remainingTime.inSeconds / _totalDuration.inSeconds)
        : 0.0;

    // Get screen size
    final size = MediaQuery.of(context).size;
    final timerSize = size.width < 600 ? size.width * 0.6 : 300.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: size.height * 0.05),
                        _buildHeader(),
                        SizedBox(height: size.height * 0.05),
                        // ...existing progress + image stack...
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: timerSize,
                              height: timerSize,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                color: const Color(0xFF2E7D32),
                                backgroundColor: Colors.white.withOpacity(0.3),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/frames/frame_($_currentFrame).gif",
                                  width: timerSize - 15,
                                  height: timerSize - 15,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.05),
                        _buildTimerControls(),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Full-screen invisible tap-catcher while sound is playing
          if (_isSoundPlaying)
            Positioned.fill(
              child: Material(
                color: Colors.black
                    .withOpacity(0.001), // invisible but catches taps
                child: InkWell(
                  onTap: _stopSoundIfPlaying,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _isCompleted ? "Growth Achieved!" : "Stay Focused",
          style: const TextStyle(
            color: Color.fromARGB(255, 253, 253, 253),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Each moment of focus cultivates your grove.",
          style: TextStyle(
            color: Color(0xFFE0E0E0).withOpacity(0.7),
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // Update _buildTimerControls() for better responsiveness
  Widget _buildTimerControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        return Column(
          children: [
            Text(
              _formatDuration(_remainingTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 40 : 60,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: constraints.maxWidth * 0.8,
              child: Slider(
                value: _totalDuration.inMinutes.toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                activeColor: const Color(0xFF64FFDA),
                inactiveColor: Colors.white.withOpacity(0.3),
                thumbColor: const Color(0xFF64FFDA),
                onChanged: _isPlaying
                    ? null
                    : (value) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _totalDuration = Duration(minutes: value.toInt());
                          _remainingTime = _totalDuration;
                        });
                      },
              ),
            ),
            Text(
              "${_totalDuration.inMinutes} minutes",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: min(200, constraints.maxWidth * 0.8),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: (_isPlaying
                            ? const Color(0xFFFF756D)
                            : const Color(0xFF2E7D32))
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPlaying
                      ? const Color(0xFFFF756D)
                      : const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _isPlaying ? _giveUp : _startTimer,
                child: Text(
                  _isPlaying ? "Give Up" : "Start Focusing",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
