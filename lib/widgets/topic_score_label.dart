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
        if (!snap.hasData) return const SizedBox.shrink();
        final s = snap.data;
        final attempted = (s?.attempted ?? 0) as int;
        final correct   = (s?.correct ?? 0) as int;
        final text = attempted == 0 ? '未挑戦' : '$attempted問中 $correct問 正解';
        return Text(text, style: style ?? const TextStyle(fontWeight: FontWeight.w600));
      },
    );
  }
}
