import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../explore/presentation/providers/community_provider.dart';
import '../../../explore/presentation/providers/memory_provider.dart';

class RecordingPreviewPage extends ConsumerWidget {
  const RecordingPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final category = extra?['category'] as String? ?? 'Leyenda';
    final title = extra?['title'] as String? ?? 'Nueva memoria';
    final transcription = extra?['transcription'] as String? ?? '';
    final selectedCommunity = ref.watch(communityProvider).selected;
    final communityId = int.tryParse(selectedCommunity?.id ?? '');

    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Vista previa',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            color: context.textPrimary,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: context.sacredJade,
                    radius: 18,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: 0.5,
                            minHeight: 4,
                            backgroundColor: context.maizeGold,
                            color: context.sacredJade,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0:45',
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '1:30',
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.edit_note, size: 18, color: context.sacredJade),
                const SizedBox(width: 6),
                Text(
                  'Transcripcion automatica',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transcription.isEmpty
                        ? 'Transcripcion no disponible.'
                        : transcription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textOnLightBody,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.edit, size: 14, color: context.sacredJade),
                      const SizedBox(width: 4),
                      Text(
                        'Editar transcripcion',
                        style: TextStyle(
                          color: context.sacredJade,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Metadatos',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMetaChip(
                  Icons.eco,
                  category,
                  AppColors.categoryColor(category),
                ),
                const SizedBox(width: 8),
                _buildMetaChip(
                  Icons.location_on,
                  selectedCommunity?.name ?? 'Comunidad',
                  context.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.sacredJade,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (communityId == null || transcription.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Faltan datos para guardar la memoria'),
                      ),
                    );
                    return;
                  }

                  final notifier = ref.read(memoryProvider.notifier);
                  final memory = await notifier.createStory(
                    categoryId: _categoryId(category),
                    communityId: communityId,
                    title: title,
                    contentText: transcription,
                  );

                  if (!context.mounted) return;

                  if (memory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          notifier.errorMessage ??
                              'No se pudo guardar la memoria',
                        ),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Memoria guardada en el corpus comunitario',
                      ),
                    ),
                  );
                  context.pop();
                },
                icon: const Icon(Icons.group_outlined, size: 20),
                label: const Text(
                  'Guardar al corpus comunitario',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Descartar',
                  style: TextStyle(color: context.textSecondary, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _categoryId(String category) {
    switch (category.toLowerCase()) {
      case 'leyenda':
        return 1;
      case 'fiesta':
        return 2;
      case 'ritual':
        return 3;
      default:
        return 1;
    }
  }
}
