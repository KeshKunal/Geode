import 'dart:async';
import 'package:flutter/material.dart';

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

  // IMPORTANT: Set this to the total number of frames you extracted from your GIF.
  // For example, if you have frame_0.png to frame_29.png, this should be 30.
  final int _totalFrames = 424; // <<<--- UPDATE THIS NUMBER

  // This will hold the current frame number to display.
  int _currentFrame = 0;

  // --- LIFECYCLE METHODS ---

  @override
  void dispose() {
    // Clean up the timer when the widget is removed.
    _timer?.cancel();
    super.dispose();
  }

  // --- TIMER LOGIC ---

  void _startTimer() {
    setState(() {
      _isPlaying = true;
      _isCompleted = false;
      _remainingTime = _totalDuration;
      _currentFrame = 0; // Start from the first frame
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
          // Every second, we update which frame of the animation to show.
          _updateImageFrame();
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isPlaying = false;
          _isCompleted = true;
          // Show the last frame when completed.
          _currentFrame = _totalFrames - 1;
        });
      }
    });
  }

  void _giveUp() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isCompleted = false;
      _remainingTime = _totalDuration;
      // Reset to the beginning.
      _currentFrame = 0;
    });
  }

  // --- FRAME LOGIC ---

  void _updateImageFrame() {
    // Calculate the progress of the timer (a value from 0.0 to 1.0).
    double progress =
        1.0 - (_remainingTime.inSeconds / _totalDuration.inSeconds);

    // Calculate which frame corresponds to the current progress.
    // We use .floor() to get a whole number.
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
    // Calculate progress for the CircularProgressIndicator.
    double progress = _isPlaying
        ? 1.0 - (_remainingTime.inSeconds / _totalDuration.inSeconds)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF4A7C59),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeader(),
                // This is your UI from before, but now it's powered by our new logic.
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        color: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipOval(
                        // The Image.asset now dynamically builds the path to the correct frame!
                        child: Image.asset(
                          "assets/images/frames/frame_($_currentFrame).gif",
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                          // This helps prevent flickering between frames.
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildTimerControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _isCompleted ? "Growth Achieved!" : "Stay Focused",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Each moment of focus cultivates your grove.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerControls() {
    return Column(
      children: [
        Text(
          _formatDuration(_remainingTime),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 20),
        Slider(
          value: _totalDuration.inMinutes.toDouble(),
          min: 1,
          max: 120,
          divisions: 119,
          label: "${_totalDuration.inMinutes} minutes",
          activeColor: Colors.white,
          inactiveColor: Colors.white.withOpacity(0.3),
          onChanged: _isPlaying
              ? null
              : (value) {
                  setState(() {
                    _totalDuration = Duration(minutes: value.toInt());
                    _remainingTime = _totalDuration;
                  });
                },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPlaying ? Colors.red[300] : Colors.white,
              foregroundColor:
                  _isPlaying ? Colors.white : const Color(0xFF4A7C59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: _isPlaying ? _giveUp : _startTimer,
            child: Text(
              _isPlaying ? "Give Up" : "Start Focusing",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
