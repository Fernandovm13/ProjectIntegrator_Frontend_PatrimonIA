import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/audio_player_widget.dart';
import '../../../../core/models/memory.dart';
import '../providers/memory_provider.dart';

class StoryDetailPage extends ConsumerWidget {
  const StoryDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memory = GoRouterState.of(context).extra as Memory;

    final months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final dateStr = '${months[memory.createdAt.month]} ${memory.createdAt.year}';

    return Scaffold(
      backgroundColor: context.surface,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.headerStart, AppColors.headerEnd],
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ref.read(memoryProvider.notifier).toggleLike(memory.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compartir próximamente')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: memory.color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(memory.icon, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          memory.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    memory.title,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${memory.location} \u{2022} ${memory.author} \u{2022} $dateStr',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _GoldDotSeparatorSmall(context),
                  const SizedBox(height: 20),
                  Text(
                    memory.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: context.textBody,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AudioPlayerWidget(),
        ],
      ),
    );
  }

  Widget _GoldDotSeparatorSmall(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        20,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: context.maizeGold,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
