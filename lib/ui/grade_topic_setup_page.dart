import 'package:flutter/material.dart';
import 'package:sealicense_mvp/widgets/topic_score_label.dart';

class GradeTopicSetupPage extends StatefulWidget {
  const GradeTopicSetupPage({super.key});
  @override
  State<GradeTopicSetupPage> createState() => _GradeTopicSetupPageState();
}

class _GradeTopicSetupPageState extends State<GradeTopicSetupPage> {
  final grades = const [1, 2, 3, 4, 5, 6];
  final topics = const ['航海', '法規', '運用', '機関']; // 仮
  int? selectedGrade;
  String? selectedTopic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('セットアップ')),
      body: SingleChildScrollView(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('級を選んでね', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                for (final g in grades)
                  ChoiceChip(
                    label: Text('$g級'),
                    selected: selectedGrade == g,
                    onSelected: (_) => setState(() {
                      selectedGrade = g;
                      selectedTopic = null; // 紐づけ直し
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('トピックを選んでね', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                for (final t in topics)
                  ChoiceChip(
                    label: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(t),
    SizedBox(height: 2),
    TopicScoreLabel(topicId: t),
  ],
),
                    selected: selectedTopic == t,
                    onSelected: selectedGrade == null ? null : (_) => setState(() => selectedTopic = t),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                FilledButton.icon(
                  onPressed: (selectedGrade != null && selectedTopic != null)
                      ? () => Navigator.pushNamed(context, '/quiz', arguments: {
                            'grade': selectedGrade,
                            'topic': selectedTopic,
                          })
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('クイズ開始'),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}



