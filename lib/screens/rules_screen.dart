import 'package:flutter/material.dart';
import 'package:geode/services/blocker_provider.dart';
import 'package:provider/provider.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final blockerProvider = Provider.of<BlockerProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        title: const Text('Blocking Rules', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF252836),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blocked Apps', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
            Expanded(
              child: ListView.builder(
                itemCount: blockerProvider.blockedApps.length,
                itemBuilder: (context, index) {
                  final app = blockerProvider.blockedApps[index];
                  return ListTile(
                    title: Text(app, style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Use the provider to remove the app
                        blockerProvider.removeApp(app);
                      },
                    ),
                  );
                },
              ),
            ),
            // Add a similar section for Blocked Websites
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can add a dialog here to add a new app/website
          // For now, let's add a test app
          blockerProvider.addApp('com.zhiliaoapp.musically'); // TikTok's package name
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}