import 'package:flutter/material.dart';
import 'package:flutter_app_shield/flutter_app_shield.dart';

void main() {
  runApp(const MyExampleApp());
}

class MyExampleApp extends StatelessWidget {
  const MyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShield(
      preventScreenshot: true,
      requireAuthOnResume: true,
      blockOnJailbreak: false,
      blurAmount: 30.0,
      opacity: 0.85,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App Shield Demo',
        home: Scaffold(
          appBar: AppBar(title: const Text('App Shield Demo')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text('This app is protected!', style: TextStyle(fontSize: 24)),
                Text('Try taking a screenshot or switching apps.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
