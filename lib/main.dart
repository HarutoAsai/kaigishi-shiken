import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/dashboard_page.dart';

void main() => runApp(const SeaQuizApp());

class SeaQuizApp extends StatelessWidget {
  const SeaQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    );

    return MaterialApp(
      title: '海技士クイズ',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.notoSansJpTextTheme(base.textTheme),
      ),
      // スクロール最適化（スマホOK）
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      home: const DashboardPage(),
    );
  }
}
