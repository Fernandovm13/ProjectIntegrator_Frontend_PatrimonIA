import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../../core/models/memory.dart';
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

  final List<String> _filters = [
    'Todos',
    'Leyendas',
    'Historia',
    'Rituales',
    'Música',
  ];

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
    final categoryMap = {
      'Leyendas': 'Leyenda',
      'Historia': 'Historia',
      'Rituales': 'Ritual',
      'Música': 'Canción',
    };
    final target = categoryMap[_activeFilter];
    if (target == null) return _searchResults;
    return _searchResults.where((m) => m.category == target).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                  onSubmitted: (value) => _performSearch(value),
                  decoration: InputDecoration(
                    hintText: 'Busca leyendas, rituales, personajes...',
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
                children: _filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: filter,
                      isSelected: _activeFilter == filter,
                      onTap: () => setState(() => _activeFilter = filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _hasSubmitted
                  ? _buildResultsView(context)
                  : _buildLandingView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandingView(BuildContext context) {
    final memories = ref.watch(memoryProvider);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          'Búsquedas recientes',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (_recentSearches.isEmpty) ...[
          _buildRecentSearch(context, 'nagual'),
          _buildRecentSearch(context, 'danza de los parachicos'),
          _buildRecentSearch(context, 'tejidos tzotzil'),
        ] else
          for (final term in _recentSearches)
            _buildRecentSearch(context, term),
        const SizedBox(height: 24),
        Text(
          'Temas populares en tu comunidad',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildTopicCard(context, Icons.eco, 'Naguales', '${memories.length} memorias'),
            _buildTopicCard(
              context,
              Icons.eco,
              'Medicina ancestral',
              '${memories.where((m) => m.category == 'Tradición').length} memorias',
            ),
            _buildTopicCard(
              context,
              Icons.auto_awesome,
              'Rituales de curación',
              '${memories.where((m) => m.category == 'Ritual').length} memorias',
            ),
            _buildTopicCard(
              context,
              Icons.agriculture,
              'Milpa sagrada',
              '${memories.where((m) => m.category == 'Tradición').length} memorias',
            ),
            _buildTopicCard(
              context,
              Icons.terrain,
              'Cerros sagrados',
              '${memories.where((m) => m.category == 'Leyenda').length} memorias',
            ),
            _buildTopicCard(
              context,
              Icons.palette,
              'Tejidos de Zinacantán',
              '${memories.where((m) => m.location.contains('Zinacantán')).length} memorias',
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
          style: TextStyle(
            color: context.textBody,
            fontSize: 14,
          ),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close, color: context.textSecondary, size: 18),
        onPressed: () {
          setState(() => _recentSearches.remove(term));
        },
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
          Text(
            count,
            style: TextStyle(fontSize: 11, color: context.maizeGold),
          ),
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
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '← Anterior',
              style: TextStyle(
                color: context.sacredJade,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '1/${results.length}',
              style: TextStyle(color: context.textSecondary, fontSize: 13),
            ),
            const SizedBox(width: 16),
            Text(
              'Siguiente →',
              style: TextStyle(
                color: context.sacredJade,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
}
