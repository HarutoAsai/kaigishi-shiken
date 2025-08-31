import 'package:flutter/material.dart';
import 'package:sealicense_mvp/services/topic_stats_service.dart';

class TopicSummaryBanner extends StatelessWidget {
  final String topicId;
  const TopicSummaryBanner({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: TopicStatsService().get(topicId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox(height: 32);
        }
        final s = snap.data;
        final attempted = (s?.attempted ?? 0) as int;
        final correct   = (s?.correct ?? 0) as int;
        final text = attempted == 0 ? '未挑戦' : '$attempted問中 $correct問 正解';
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
