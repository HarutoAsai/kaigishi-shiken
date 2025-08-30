import 'package:flutter/material.dart';
import 'package:sealicense_mvp/services/topic_stats_service.dart';

class TopicScoreLabel extends StatelessWidget {
  final String topicId;
  final String prefix;
  final TextStyle? style;
  const TopicScoreLabel({super.key, required this.topicId, this.prefix = '', this.style});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TopicStats>(
      future: TopicStatsService().get(topicId),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        final s = snap.data!;
        if (s.attempted == 0) return Text('未挑戦', style: style);
        return Text('問中 問 正解',
          style: style ?? const TextStyle(fontWeight: FontWeight.w500));
      },
    );
  }
}
