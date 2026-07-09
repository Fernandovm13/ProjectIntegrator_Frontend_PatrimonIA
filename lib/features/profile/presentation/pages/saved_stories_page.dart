import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/memory.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../explore/presentation/providers/memory_provider.dart';

class SavedStoriesPage extends ConsumerStatefulWidget {
  const SavedStoriesPage({super.key});

  @override
  ConsumerState<SavedStoriesPage> createState() => _SavedStoriesPageState();
}

class _SavedStoriesPageState extends ConsumerState<SavedStoriesPage> {
  late Future<List<Memory>> _favorites;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _favorites = ref.read(memoryProvider.notifier).loadFavoriteStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        title: Text(
          'Historias guardadas',
          style: TextStyle(color: context.textPrimary),
        ),
      ),
      body: FutureBuilder<List<Memory>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No se pudieron cargar tus historias guardadas.'),
                  const SizedBox(height: 8),
                  IconButton(
                    tooltip: 'Reintentar',
                    onPressed: () => setState(_load),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          }
          final favorites = snapshot.data ?? const [];
          if (favorites.isEmpty) {
            return const Center(child: Text('Aun no has guardado historias.'));
          }
          return RefreshIndicator(
            onRefresh: () async => setState(_load),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final memory = favorites[index];
                return ListTile(
                  tileColor: context.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: context.border),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: memory.color.withValues(alpha: 0.15),
                    child: Icon(memory.icon, color: memory.color),
                  ),
                  title: Text(memory.title),
                  subtitle: Text('${memory.category} · ${memory.community}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/detail', extra: memory),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
