import 'package:flutter/material.dart';
import 'package:geode/services/widget_support.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "My Grove",
        style: AppWidget.healinetextstyle(20.0),
      )),
    );
  }
}
