import 'package:flutter/material.dart';
import 'package:sealicense_mvp/services/topic_stats_service.dart';

class TopicScoreLabel extends StatelessWidget {
  final String topicId;
  final TextStyle? style;
  const TopicScoreLabel({super.key, required this.topicId, this.style});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: TopicStatsService().get(topicId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        try {
          final data = snap.data;
          int attempted = 0;
          int correct = 0;

          if (data is Map) {
            final a = data['attempted'];
            final c = data['correct'];
            if (a is num) attempted = a.toInt();
            if (c is num) correct = c.toInt();
          }

          final text = attempted == 0 ? '未挑戦' : '$attempted問中 $correct問 正解';
          return Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          );
        } catch (_) {
          // 何かあっても落とさない
          return const SizedBox.shrink();
        }
      },
    );
  }
}
