import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('海技士 学習ダッシュボード（復旧版）')),
      body: const SafeArea(
        child: Center(
          child: Text('まずは起動できればOK。ここから少しずつ戻します。'),
        ),
      ),
    );
  }
}