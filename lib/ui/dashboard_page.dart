import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFFEBF3FF), Color(0xFFF8FBFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('海技士 学習ダッシュボード')),
      body: Stack(
        children: [
          // 背景：タッチ無視（スクロール奪わない）
          IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(gradient: gradient)),
                Positioned(top: -80, left: -40, child: _blurCircle(220, const Color(0xFFB3E5FC))),
                Positioned(bottom: -60, right: -30, child: _blurCircle(260, const Color(0xFFC5CAE9))),
              ],
            ),
          ),

          // 前面
          SafeArea(
            child: LayoutBuilder(
              builder: (_, c) {
                final isNarrow = c.maxWidth < 680; // ← ここでスマホ判定

                final heroText = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ようこそ！', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('級を選んで → トピックを選んで → クイズ開始！'),
                    const SizedBox(height: 12),
                    isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/setup'),
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('級から選んで始める'),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/quiz'),
                                icon: const Icon(Icons.bolt),
                                label: const Text('すぐにクイズ（デモ）'),
                              ),
                            ],
                          )
                        : Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/setup'),
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('級から選んで始める'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/quiz'),
                                icon: const Icon(Icons.bolt),
                                label: const Text('すぐにクイズ（デモ）'),
                              ),
                            ],
                          ),
                  ],
                );

                final mascot = _Glass(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: isNarrow ? 160 : (kIsWeb ? 220 : 180),
                    height: isNarrow ? 160 : (kIsWeb ? 220 : 180),
                    child: const _Mascot(),
                  ),
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Glass(
                        padding: const EdgeInsets.all(16),
                        child: isNarrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  heroText,
                                  const SizedBox(height: 12),
                                  mascot,
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: heroText),
                                  const SizedBox(width: 16),
                                  mascot,
                                ],
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text('最近の正答率', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      const _Glass(
                        padding: EdgeInsets.all(16),
                        child: Text('（ここに正答率やお知らせなどを表示予定）'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Glass({required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.6),
        shadows: const [BoxShadow(blurRadius: 16, offset: Offset(0, 8), color: Color(0x1F000000))],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _Mascot extends StatelessWidget {
  const _Mascot();

  @override
  Widget build(BuildContext context) {
    // 1) アセット → 2) Web → 3) アイコン の順にフォールバック
    return Image.asset(
      'assets/images/mascot_v2.png',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return Image.network(
          'https://harutoasai.github.io/kaigishi-shiken/assets/images/mascot_v2.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.sailing, size: 120, color: Colors.indigo),
        );
      },
    );
  }
}
