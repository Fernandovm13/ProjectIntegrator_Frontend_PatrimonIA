import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/memory.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../explore/presentation/providers/memory_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'Todos';
  bool _hasSubmitted = false;
  List<Memory> _searchResults = [];
  List<String> _recentSearches = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final results = ref.read(memoryProvider.notifier).search(trimmed);
    setState(() {
      _searchResults = results;
      _hasSubmitted = true;
      if (!_recentSearches.contains(trimmed)) {
        _recentSearches.insert(0, trimmed);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.sublist(0, 5);
        }
      }
    });
  }

  List<Memory> _filteredResults() {
    if (_activeFilter == 'Todos') return _searchResults;
    return _searchResults.where((m) => m.category == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final memories = ref.watch(memoryProvider);
    final filters = [
      'Todos',
      ...{for (final memory in memories) memory.category},
    ];
    if (!filters.contains(_activeFilter)) {
      _activeFilter = 'Todos';
    }

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: context.textPrimary),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Busca memorias comunitarias...',
                    hintStyle: TextStyle(color: context.textSecondary),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search, color: context.textSecondary),
                      onPressed: () => _performSearch(_searchController.text),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: context.textSecondary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _hasSubmitted = false);
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final filter in filters)
                    Padding(
                      padding: EdgeInsets.only(
                        right: filter != filters.last ? 8 : 0,
                      ),
                      child: CategoryChip(
                        label: filter,
                        isSelected: _activeFilter == filter,
                        onTap: () => setState(() => _activeFilter = filter),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _hasSubmitted
                  ? _buildResultsView(context)
                  : _buildLandingView(context, memories),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandingView(BuildContext context, List<Memory> memories) {
    final popularTopics = _popularTopics(memories);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          'Busquedas recientes',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (_recentSearches.isEmpty)
          Text(
            'Aun no has buscado memorias.',
            style: TextStyle(color: context.textSecondary, fontSize: 13),
          )
        else
          for (final term in _recentSearches) _buildRecentSearch(context, term),
        const SizedBox(height: 24),
        Text(
          'Temas disponibles',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (popularTopics.isEmpty)
          Text(
            'No hay temas disponibles.',
            style: TextStyle(color: context.textSecondary, fontSize: 13),
          )
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              for (final topic in popularTopics)
                _buildTopicCard(
                  context,
                  topic.icon,
                  topic.name,
                  '${topic.count} memorias',
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildRecentSearch(BuildContext context, String term) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.access_time, color: context.textSecondary, size: 20),
      title: InkWell(
        onTap: () {
          _searchController.text = term;
          _performSearch(term);
        },
        child: Text(
          term,
          style: TextStyle(color: context.textBody, fontSize: 14),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close, color: context.textSecondary, size: 18),
        onPressed: () => setState(() => _recentSearches.remove(term)),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    IconData icon,
    String name,
    String count,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: context.maizeGold),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(count, style: TextStyle(fontSize: 11, color: context.maizeGold)),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context) {
    final results = _filteredResults();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          '${results.length} resultados para "${_searchController.text}"',
          style: TextStyle(fontSize: 13, color: context.textSecondary),
        ),
        const SizedBox(height: 12),
        for (final memory in results)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildResultCard(context, memory),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultCard(BuildContext context, Memory memory) {
    return GestureDetector(
      onTap: () => context.push('/detail', extra: memory),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: memory.color,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(memory.icon, size: 10, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        memory.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              memory.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              memory.content.length > 100
                  ? '${memory.content.substring(0, 100)}...'
                  : memory.content,
              style: TextStyle(
                fontSize: 13,
                color: context.textBody,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_Topic> _popularTopics(List<Memory> memories) {
    final grouped = <String, _Topic>{};
    for (final memory in memories) {
      final current = grouped[memory.category];
      grouped[memory.category] = _Topic(
        name: memory.category,
        icon: memory.icon,
        count: (current?.count ?? 0) + 1,
      );
    }
    final topics = grouped.values.toList();
    topics.sort((a, b) => b.count.compareTo(a.count));
    return topics.take(6).toList();
  }
}

class _Topic {
  final String name;
  final IconData icon;
  final int count;

  const _Topic({required this.name, required this.icon, required this.count});
}
