import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/login_page.dart';
import 'package:flutterestudo/pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MainPage(),
    );
  }
}
