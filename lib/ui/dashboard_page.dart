import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int todayGoal = 20;
  int todayDone = 7;
  final recentAccuracies = <double>[0.6, 0.8, 0.55, 0.7, 0.9, 0.65, 0.75];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const gradient = LinearGradient(
      colors: [Color(0xFFEBF3FF), Color(0xFFF8FBFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('HOME v3 確認用🚀 build-check-01')),
      body: Stack(
        children: [
          // 背景
          Container(decoration: const BoxDecoration(gradient: gradient)),
          Positioned(top: -80, left: -40, child: _blurCircle(220, const Color(0xFFB3E5FC))),
          Positioned(bottom: -60, right: -30, child: _blurCircle(260, const Color(0xFFC5CAE9))),

          // 本文
          SafeArea(
            child: LayoutBuilder(
              builder: (_, c) {
                final isWide = c.maxWidth >= 900;

final header = _GlassCard(
  child: LayoutBuilder(
    builder: (context, box) {
      final isNarrow = box.maxWidth < 720; // 狭いときは縦並び

      final bubble = Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520), // 取りすぎ防止
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Text(
              '今日の目標、いっしょにがんばろう！',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F1A2A),
              ),
              // ← 省略しない＆必要なら改行OK
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      );

      final left = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _MascotImage(size: 128),
          const SizedBox(width: 12),
          bubble,
        ],
      );

      final cta = FilledButton.icon(
        onPressed: () => Navigator.of(context).pushNamed('/quiz'),
        icon: const Icon(Icons.play_arrow),
        label: const Text('クイックスタート'),
      );

      // 狭い時は縦、広い時は横で両端寄せ
      return isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: cta),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.space-between,
              children: [
                Expanded(child: left), // 左側に十分な幅を確保
                const SizedBox(width: 12),
                cta,
              ],
            );
    },
  ),
);

                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed('/quiz'),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('クイックスタート'),
                      ),
                    ],
                  ),
                );

                final body = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    const SizedBox(height: 12),
                    _TodayCard(
                      done: todayDone,
                      goal: todayGoal,
                      onStart: () => Navigator.of(context).pushNamed('/quiz'),
                    ),
                    const SizedBox(height: 12),
                    _MiniTrendCard(values: recentAccuracies),
                    const SizedBox(height: 12),
                    Text('クイックスタート', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TopicChip(label: '航海', onTap: () => Navigator.of(context).pushNamed('/quiz')),
                        _TopicChip(label: '機関', onTap: () => Navigator.of(context).pushNamed('/quiz')),
                        _TopicChip(label: '法規', onTap: () => Navigator.of(context).pushNamed('/quiz')),
                      ],
                    ),
                  ],
                );

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: body),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: _TipsCard(
                                    lines: [
                                      'ポイント：短時間でも毎日触る',
                                      '間違えた問題を翌日に復習',
                                      '模擬試験は週1回で良い',
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : body,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _blurCircle(double size, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.25)),
        ),
      ),
    );
  }
}

/// ガラス風カード
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.10),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                spreadRadius: -4,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// マスコット画像（Web/ローカル両対応）
class _MascotImage extends StatelessWidget {
  const _MascotImage({this.size = 140});
  final double size;

  @override
  Widget build(BuildContext context) {
    const assetPath = 'assets/images/mascot_v2.png';
    const webUrl =
        'https://harutoasai.github.io/kaigishi-shiken/assets/assets/images/mascot_v2.png';
    return kIsWeb
        ? Image.network(webUrl, width: size, height: size, errorBuilder: (_, __, ___) {
            return const Text('🐧(web) 読み込み失敗');
          })
        : Image.asset(assetPath, width: size, height: size, errorBuilder: (_, __, ___) {
            return const Text('🐧(asset) 見つからない');
          });
  }
}

/* ===================== ここから下は既存カード群（そのまま） ===================== */

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.done, required this.goal, required this.onStart});
  final int done;
  final int goal;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final p = (done / goal).clamp(0.0, 1.0);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 56,
              width: 56,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(value: p),
                  Center(child: Text('${(p * 100).round()}%')),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text('今日の目標：$goal 問\n完了：$done 問', style: Theme.of(context).textTheme.titleMedium),
            ),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('演習を開始'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTrendCard extends StatelessWidget {
  const _MiniTrendCard({required this.values});
  final List<double> values; // 0.0–1.0

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('最近の正答率', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(height: 56, child: _Sparkline(values: values)),
          ],
        ),
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.values});
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(values),
      child: const SizedBox.expand(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF1E88E5);

    final path = Path();
    final n = values.length;
    for (int i = 0; i < n; i++) {
      final x = i == n - 1 ? size.width : (size.width * i / (n - 1));
      final y = size.height * (1 - values[i].clamp(0.0, 1.0));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // 50% ガイド
    final guide = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x331E88E5);
    final y50 = size.height * 0.5;
    canvas.drawLine(Offset(0, y50), Offset(size.width, y50), guide);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) => old.values != values;
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.navigation_outlined, size: 18),
      onPressed: onTap,
      shape: StadiumBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.lines});
  final List<String> lines;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('学習ヒント', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...lines.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
