import 'package:flutter/material.dart';
import 'package:danweizhuanhuan/screens/home_screen.dart'; // 导入主页

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '单位转换器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), // 设置你的主页
    );
  }
}