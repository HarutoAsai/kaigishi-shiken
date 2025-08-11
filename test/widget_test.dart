import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/mascot.png',
          width: 180,
          height: 180,
          errorBuilder: (_, __, ___) => const Text('🐧が見つからない…'),
        ),
      ),
    );
  }
}
