import 'package:flutter/material.dart';
import 'package:sealicense_mvp/services/topic_stats_service.dart';

class TopicResultPage extends StatelessWidget{
  final String topicId;
  final String topicTitle;
  final int sessionAttempted;
  final int sessionCorrect;

  const TopicResultPage({
    super.key,
    required this.topicId,
    required this.topicTitle,
    required this.sessionAttempted,
    required this.sessionCorrect,
  });

  static Future<void> show(
    BuildContext context, {
    required String topicId,
    required String topicTitle,
    required int sessionAttempted,
    required int sessionCorrect,
  }) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TopicResultPage(
        topicId: topicId,
        topicTitle: topicTitle,
        sessionAttempted: sessionAttempted,
        sessionCorrect: sessionCorrect,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context){
    final h = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('リザルト')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(topicTitle, style: h.titleLarge),
                const SizedBox(height: 16),

                Card(
                  elevation: .5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('今回の結果', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                          '\問中 \問 正解',
                          style: h.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                FutureBuilder<TopicStats>(
                  future: TopicStatsService().get(topicId),
                  builder: (context, snap){
                    if (!snap.hasData) return const SizedBox.shrink();
                    final s = snap.data!;
                    final text = (s.attempted == 0)
                      ? '通算：まだ記録がありません'
                      : '通算：\問中 \問 正解';
                    return Card(
                      elevation: .5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.assessment_outlined),
                            const SizedBox(width: 12),
                            Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('ホームへ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.replay),
                        label: const Text('もう一度'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
