import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/memory.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/memory_provider.dart';

class HomeGuardianPage extends ConsumerStatefulWidget {
  const HomeGuardianPage({super.key});

  @override
  ConsumerState<HomeGuardianPage> createState() => _HomeGuardianPageState();
}

class _HomeGuardianPageState extends ConsumerState<HomeGuardianPage> {
  String _selectedCategory = 'Leyendas';

  @override
  Widget build(BuildContext context) {
    final memories = ref.watch(memoryProvider);
    final user = ref.watch(authProvider).user;
    final categories = [
      ...{for (final memory in memories) memory.category},
    ];
    if (categories.isNotEmpty && !categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    final categoryFilter = _selectedCategory;

    List<Memory> displayMemories;
    if (categoryFilter == 'Todos' || categories.isEmpty) {
      displayMemories = List.from(memories);
    } else {
      displayMemories = memories
          .where((m) => m.category == categoryFilter)
          .toList();
    }
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
                      color: context.warmAmber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Modo Guardián activo',
                          style: TextStyle(
                            color: Colors.white,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.maizeGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus memorias guardadas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${memories.length} testimonios en el corpus comunitario',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.sacredJade,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => context.push('/record'),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text(
                                'Nueva memoria',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.textPrimary,
                                side: BorderSide(color: context.textBody),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => context.push('/stats'),
                              icon: const Icon(Icons.bar_chart, size: 18),
                              label: const Text(
                                'Estadísticas',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explorar por tema',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: context.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Ver todo',
                      style: TextStyle(
                        color: context.sacredJade,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final entry in categories)
                      Padding(
                        padding: EdgeInsets.only(
                          right: entry != categories.last ? 8 : 0,
                        ),
                        child: CategoryChip(
                          label: entry,
                          isSelected: _selectedCategory == entry,
                          onTap: () =>
                              setState(() => _selectedCategory = entry),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Memorias recientes',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: context.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Ver todo',
                      style: TextStyle(
                        color: context.sacredJade,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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

  String _userInitial(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'U';
    return trimmed[0].toUpperCase();
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
                      Text(
                        memory.location,
                        style: TextStyle(
                          fontSize: 10,
                          color: context.textSecondary,
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
}
