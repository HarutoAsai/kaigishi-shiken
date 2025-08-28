import 'package:flutter/material.dart';
import 'ui/dashboard_page.dart';

void main() => runApp(const SeaQuizApp());

class SeaQuizApp extends StatelessWidget {
  const SeaQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '海技士クイズ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFF7F9FC),
      ),
      home: const DashboardPage(),
    );
  }
}