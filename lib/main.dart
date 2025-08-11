import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'ui/dashboard_page.dart';

void main() => runApp(const SeaQuizApp());

class SeaQuizApp extends StatelessWidget {
  const SeaQuizApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '海技士クイズv2.home3',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      // ← ここをダッシュボードに
      home: const DashboardPage(),

      // ← ここで Quiz 画面への“名前付きルート”を定義
      routes: {
        '/quiz': (context) => const QuizPage(),
      },
    );
  }
}


class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _loading = true;
  late final List<_Q> _qs;
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/questions.json');
    final List data = jsonDecode(raw) as List;

    final rng = Random();
    _qs = data.map((e) {
      final question = e['question'] as String;
      final List<String> options = (e['options'] as List).cast<String>().toList();
      final int correct = e['answer'] as int;
      final String? explanation = e['explanation'] as String?;
      final idx = List<int>.generate(options.length, (i) => i)..shuffle(rng);
      final shuffled = [for (final i in idx) options[i]];
      final newAnswer = idx.indexOf(correct);
      return _Q(question: question, options: shuffled, answer: newAnswer, explanation: explanation);
    }).toList();

    setState(() => _loading = false);
  }

  void _onSelect(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == _qs[_index].answer) _score++;
    });
  }

  void _next() {
    if (_index < _qs.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _answered = false;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultPage(score: _score, total: _qs.length, onRetry: _reset),
        ),
      );
    }
  }

  void _reset() {
    Navigator.of(context).popUntil((r) => r.isFirst);
    setState(() {
      _index = 0;
      _score = 0;
      _selected = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _qs[_index];
    final total = _qs.length;
    final progress = (_index + 1) / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('海技士クイズv2.1'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Chip(
              label: Text('${_index + 1}/$total'),
              avatar: const Icon(Icons.anchor, size: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress, minHeight: 6),
            const SizedBox(height: 16),
            // 質問カード
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.help_outline, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(q.question, style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 選択肢（アニメで切替）
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: ListView.separated(
                  key: ValueKey(_index), // 質問が変わるたびにアニメ
                  itemCount: q.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final isCorrect = i == q.answer;
                    final isChosen = i == _selected;
                    Color? bg;
                    Color? fg;
                    IconData lead = Icons.circle_outlined;

                    if (_answered) {
                      if (isCorrect) {
                        bg = Colors.green.shade50;
                        fg = Colors.green.shade800;
                        lead = Icons.check_circle;
                      } else if (isChosen) {
                        bg = Colors.red.shade50;
                        fg = Colors.red.shade800;
                        lead = Icons.cancel;
                      }
                    }

                    return Material(
                      color: bg ?? Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _onSelect(i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          child: Row(
                            children: [
                              Icon(lead, color: fg),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${String.fromCharCode(0x41 + i)}. ${q.options[i]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: fg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_answered && q.explanation != null) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.indigo.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.menu_book, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Expanded(child: Text('解説：${q.explanation!}')),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Text('スコア: $_score / $total'),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _answered ? _next : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_index < total - 1 ? '次へ' : '結果'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Q {
  final String question;
  final List<String> options;
  final int answer;
  final String? explanation;
  _Q({required this.question, required this.options, required this.answer, this.explanation});
}

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  const ResultPage({super.key, required this.score, required this.total, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(title: const Text('結果')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text('おつかれさま！', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('スコア: $score / $total（$percent%）', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.replay),
                    label: const Text('もう一度'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
