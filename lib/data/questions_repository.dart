import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

class QuestionsRepository {
  const QuestionsRepository();

  Future<List<Question>> loadAll() async {
    const path = 'assets/questions/questions.json';
    try {
      String raw = await rootBundle.loadString(path);

      // 先頭BOM(U+FEFF)対策
      if (raw.isNotEmpty && raw.codeUnitAt(0) == 0xFEFF) {
        raw = raw.substring(1);
      }

      final jsonList = json.decode(raw) as List;
      final list = jsonList
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();

      // デバッグ：読み込んだ件数を出す（本番でもConsoleに出ます）
      // ignore: avoid_print
      print('[QuestionsRepository] loaded ${list.length} items from $path');
      return list;
    } catch (e, st) {
      // ignore: avoid_print
      print('[QuestionsRepository] failed to load $path → fallback. Error: $e');
      // print(st); // 必要ならスタックも
      return _sample;
    }
  }

  // 読み込み失敗時のフォールバック（最少限）
  static final List<Question> _sample = [
    Question(
      id: 'S-001',
      category: '法規',
      body: '航行中の船舶が夜間に表示すべき灯火として正しいものはどれ？（一般例）',
      choices: ['右舷灯は赤・左舷灯は緑', '右舷灯は緑・左舷灯は赤', '両舷灯は白', '船尾灯は赤'],
      answerIndex: 1,
      explanation: '右舷=緑、左舷=赤、船尾灯=白が基本。',
    ),
    Question(
      id: 'S-002',
      category: '運用',
      body: '推進停止後も惰性で前進する現象の主な原因はどれ？',
      choices: ['船体の横揺れ', '慣性', '風圧', 'プロペラ逆転'],
      answerIndex: 1,
      explanation: '運動は慣性で継続。推力がゼロでも速度はすぐにはゼロにならない。',
    ),
    Question(
      id: 'S-003',
      category: '機関',
      body: 'ディーゼル機関の過給機の主目的は？',
      choices: ['排気温度の低下', '給気の加圧による出力向上', '潤滑油圧の上昇', '冷却水流量の増加'],
      answerIndex: 1,
      explanation: '過給＝給気を圧縮しシリンダ充填を増やす→出力向上。',
    ),
  ];
}
