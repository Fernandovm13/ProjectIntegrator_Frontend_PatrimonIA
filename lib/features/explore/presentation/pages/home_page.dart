import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/memory.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/community_provider.dart';
import '../providers/memory_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final memories = ref.watch(memoryProvider);
    final community = ref.watch(communityProvider);
    final user = ref.watch(authProvider).user;
    final categories = [
      'Todos',
      ...{for (final memory in memories) memory.category},
    ];

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = 'Todos';
    }

    final featuredMemories = memories.where((m) => m.isFeatured).toList();
    final featuredMemory = featuredMemories.isNotEmpty
        ? featuredMemories.first
        : memories.isNotEmpty
        ? memories.first
        : null;
    final displayMemories = _selectedCategory == 'Todos'
        ? List<Memory>.from(memories)
        : memories.where((m) => m.category == _selectedCategory).toList();
    displayMemories.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.copalBrown,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: context.maizeGold,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          community.selected?.name ?? 'Comunidad',
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          color: context.textPrimary,
                        ),
                        onPressed: () => context.push('/notifications'),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: context.sacredJade,
                        child: Text(
                          _userInitial(user?.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Historia destacada',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: featuredMemory != null
                    ? () => context.push('/story-detail', extra: featuredMemory)
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.headerStart, AppColors.headerEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.maizeGold,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Historia destacada',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        featuredMemory?.title ?? 'Sin historias disponibles',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                featuredMemory?.duration ?? '0 min',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _sectionHeader(context, 'Explorar por tema'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in categories)
                      Padding(
                        padding: EdgeInsets.only(
                          right: category != categories.last ? 8 : 0,
                        ),
                        child: CategoryChip(
                          label: category,
                          isSelected: _selectedCategory == category,
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader(context, 'Memorias recientes'),
              const SizedBox(height: 12),
              if (displayMemories.isEmpty)
                Text(
                  'No hay memorias disponibles.',
                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                )
              else
                ...displayMemories.map(
                  (memory) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildMemoryCard(context, memory),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryCard(BuildContext context, Memory memory) {
    return GestureDetector(
      onTap: () => context.push('/detail', extra: memory),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: memory.color.withValues(alpha: 0.15),
              child: Icon(memory.icon, color: memory.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: memory.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          memory.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: memory.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 10,
                        color: context.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          memory.location,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  memory.duration,
                  style: TextStyle(fontSize: 11, color: context.textSecondary),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _userInitial(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'U';
    return trimmed[0].toUpperCase();
  }
}
