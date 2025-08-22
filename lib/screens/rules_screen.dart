import 'package:flutter/material.dart';
import 'package:geode/services/blocker_provider.dart';
import 'package:provider/provider.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool isPackageNameEmpty = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              decoration: const BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add App to Block', style: AppTextStyles.subheading),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Package Name (e.g., com.example.app)',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: isPackageNameEmpty ? Colors.red : Colors.grey,
                      ),
                      errorText: isPackageNameEmpty ? '*required' : null,
                    ),
                    style: AppTextStyles.body,
                    onChanged: (value) {
                      if (isPackageNameEmpty) {
                        setState(() => isPackageNameEmpty = false);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (controller.text.isEmpty) {
                          setState(() => isPackageNameEmpty = true);
                          return;
                        }
                        context.read<BlockerProvider>().addApp(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Add App',
                        style: TextStyle(color: AppColors.primaryBackground),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockerProvider = Provider.of<BlockerProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Make your own Rules',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add disclaimer banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[400], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This feature is currently in development and may not function as intended. We\'re working on improvements.',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.amber[200],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('Blocked Apps',
                style: AppTextStyles.subheading.copyWith(color: Colors.white)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: blockerProvider.blockedApps.length,
                itemBuilder: (context, index) {
                  final app = blockerProvider.blockedApps[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(app,
                          style: AppTextStyles.body
                              .copyWith(color: Colors.white70)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => blockerProvider.removeApp(app),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.highlight,
        child: const Icon(Icons.add, color: AppColors.primaryBackground),
      ),
    );
  }
}
