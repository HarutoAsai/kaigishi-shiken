import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _loading = true;
  List<_Q> _qs = [];
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  int? chosenGrade;
  String? chosenTopic;

  late SharedPreferences _prefs;
  final Map<String, _Stat> _stats = {}; // id -> stat

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final args = (ModalRoute.of(context)?.settings.arguments ?? {}) as Map?;
    chosenGrade = args?['grade'] as int?;
    chosenTopic = args?['topic'] as String?;

    _prefs = await SharedPreferences.getInstance();

    final raw = await rootBundle.loadString('assets/questions.json');
    final List list = jsonDecode(raw) as List;
    final all = list.map((e) => _Q.fromMap(e as Map<String, dynamic>)).toList();

    Iterable<_Q> filtered = all;
    if (chosenGrade != null) filtered = filtered.where((q) => q.grade == chosenGrade);
    if (chosenTopic != null && chosenTopic!.isNotEmpty) filtered = filtered.where((q) => q.topic == chosenTopic);

    final rng = Random();
    _qs = filtered.toList()..shuffle(rng);
    if (_qs.isEmpty) {
      _qs = (all..shuffle(rng)).take(10).toList();
    }

    // load per-question stats
    for (final q in _qs) {
      final a = _prefs.getInt('stats:${q.id}:attempts') ?? 0;
      final c = _prefs.getInt('stats:${q.id}:correct') ?? 0;
      _stats[q.id] = _Stat(a, c);
    }

    setState(() => _loading = false);
  }

  Future<void> _recordResult(_Q q, bool isCorrect) async {
    final stat = _stats[q.id] ?? _Stat(0, 0);
    stat.attempts += 1;
    if (isCorrect) stat.correct += 1;
    _stats[q.id] = stat;
    await _prefs.setInt('stats:${q.id}:attempts', stat.attempts);
    await _prefs.setInt('stats:${q.id}:correct', stat.correct);
  }

  void _onSelect(int i) {
    if (_answered) return;
    final isCorrect = i == _qs[_index].answer;
    setState(() {
      _selected = i;
      _answered = true;
      if (isCorrect) _score++;
    });
    _recordResult(_qs[_index], isCorrect);
  }

  void _next() {
    if (_index < _qs.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('結果'),
        content: Text('スコア: $_score / ${_qs.length}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _qs[_index];
    final total = _qs.length;
    final progress = (_index + 1) / total;
    final stat = _stats[q.id] ?? _Stat(0, 0);
    final rate = stat.attempts == 0 ? null : (stat.correct / stat.attempts);

    return Scaffold(
      appBar: AppBar(
        title: Text(chosenGrade != null && chosenTopic != null ? '${chosenGrade}級 / $chosenTopic' : 'クイズ'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Chip(label: Text('${_index + 1}/$total'), avatar: const Icon(Icons.anchor, size: 18)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress, minHeight: 6),
            const SizedBox(height: 12),

            // 質問カード（上は固定）
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.help_outline, size: 24),
                      const SizedBox(width: 12),
                      Expanded(child: Text(q.question, style: Theme.of(context).textTheme.titleMedium)),
                    ]),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          avatar: const Icon(Icons.insights, size: 18),
                          label: Text(
                            rate == null ? 'この問題の正答率 ー %（初回）' : 'この問題の正答率 ${ (rate * 100).toStringAsFixed(0) }%',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 選択肢（ここが縦スクロール領域）
            Expanded(
              child: ListView.separated(
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
                      bg = Colors.green.withOpacity(0.08);
                      fg = Colors.green.shade800;
                      lead = Icons.check_circle;
                    } else if (isChosen) {
                      bg = Colors.red.withOpacity(0.08);
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(lead, color: fg),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${String.fromCharCode(0x41 + i)}. ${q.options[i]}',
                                style: TextStyle(fontSize: 16, color: fg),
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

            if (_answered && q.explanation != null) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.indigo.withOpacity(0.06),
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
  final String id;
  final int grade;
  final String topic;
  final String question;
  final List<String> options;
  final int answer;
  final String? explanation;

  _Q({
    required this.id,
    required this.grade,
    required this.topic,
    required this.question,
    required this.options,
    required this.answer,
    this.explanation,
  });

  factory _Q.fromMap(Map<String, dynamic> m) {
    final options = (m['options'] as List).cast<String>().toList();
    final correct = m['answer'] as int;
    // シャッフルして正解位置を再計算
    final idx = List<int>.generate(options.length, (i) => i)..shuffle();
    final shuffled = [for (final i in idx) options[i]];
    final newAnswer = idx.indexOf(correct);
    return _Q(
      id: m['id'] as String,
      grade: (m['grade'] as num).toInt(),
      topic: m['topic'] as String,
      question: m['question'] as String,
      options: shuffled,
      answer: newAnswer,
      explanation: m['explanation'] as String?,
    );
  }
}

class _Stat {
  int attempts;
  int correct;
  _Stat(this.attempts, this.correct);
}
