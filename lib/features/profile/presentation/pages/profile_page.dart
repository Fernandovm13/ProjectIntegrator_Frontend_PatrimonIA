import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/memory.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../explore/presentation/providers/memory_provider.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final memories = ref.watch(memoryProvider);

    return Scaffold(
      backgroundColor: context.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 210,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.headerStart, AppColors.headerEnd],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: context.sacredJade,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.maizeGold, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 31,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.name ?? 'Usuario',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeaderChip(
                        context,
                        Icons.auto_awesome,
                        user?.role ?? 'Explorador',
                        context.maizeGold,
                      ),
                      if (user?.isPremium == true) ...[
                        const SizedBox(width: 6),
                        _buildHeaderChip(
                          context,
                          Icons.workspace_premium,
                          'Premium',
                          context.sacredJade,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        '${user?.storiesSaved ?? 0}',
                        'Historias guardadas',
                        onTap: () => context.push('/saved-stories'),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        '${user?.storiesRead ?? 0}',
                        'Historias leidas',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        '${user?.reputationScore ?? 0}',
                        'Reputacion',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mis memorias guardadas',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: context.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/saved-stories'),
                        child: const Text('Ver todas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (final memory in memories.where(
                    (item) => item.isFavorite,
                  ))
                    _buildMemoryItem(context, memory, ref),
                  const SizedBox(height: 24),
                  Text(
                    'Configuracion',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: authState.isLoading
                        ? null
                        : () => ref.read(authProvider.notifier).fetchProfile(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: context.sacredJade,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          authState.isLoading
                              ? 'Actualizando perfil...'
                              : 'Actualizar perfil',
                          style: TextStyle(
                            color: context.sacredJade,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (authState.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      authState.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => ref.read(authProvider.notifier).logout(),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: context.warmAmber, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Cerrar sesion',
                          style: TextStyle(
                            color: context.warmAmber,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: context.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.border, width: 0.5),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: context.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryItem(BuildContext context, Memory memory, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/detail', extra: memory),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border, width: 0.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: memory.color.withValues(alpha: 0.15),
              child: Icon(memory.icon, color: memory.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                memory.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: context.textPrimary,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: context.textSecondary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editar: ${memory.title}')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: context.textSecondary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eliminar: ${memory.title}')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
