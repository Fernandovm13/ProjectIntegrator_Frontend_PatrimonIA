import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../core/models/community.dart';
import '../../../explore/presentation/providers/community_provider.dart';

class CommunitySelectorPage extends ConsumerStatefulWidget {
  const CommunitySelectorPage({super.key});

  @override
  ConsumerState<CommunitySelectorPage> createState() => _CommunitySelectorPageState();
}

class _CommunitySelectorPageState extends ConsumerState<CommunitySelectorPage> {
  String? selectedCommunityName;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider);
    final communities = communityState.communities;

    final filtered = _searchController.text.isEmpty
        ? communities
        : communities.where((c) =>
            c.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    final regions = <String, List<Community>>{};
    for (final c in filtered) {
      regions.putIfAbsent(c.region, () => []).add(c);
    }

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: context.textPrimary,
                    ),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: context.card,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Buscar comunidad...',
                        hintStyle: TextStyle(color: context.textSecondary),
                        prefixIcon: Icon(
                          Icons.search,
                          color: context.textSecondary,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final entry in regions.entries) ...[
                    _buildRegionHeader(context, '📍 ${entry.key}'),
                    for (final community in entry.value)
                      _buildCommunityTile(context, community),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.sacredJade,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedCommunityName != null) {
                      final selected = communities.firstWhere(
                        (c) => c.name == selectedCommunityName,
                      );
                      ref.read(communityProvider.notifier).select(selected);
                    }
                    context.pop();
                  },
                  child: const Text(
                    'Confirmar comunidad',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: TextStyle(
          color: context.maizeGold,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCommunityTile(BuildContext context, Community community) {
    final isSelected = selectedCommunityName == community.name;
    return InkWell(
      onTap: () => setState(() => selectedCommunityName = community.name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.sacredJade : context.border,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: community.name,
              groupValue: selectedCommunityName,
              onChanged: (value) {
                if (value != null) setState(() => selectedCommunityName = value);
              },
              activeColor: context.sacredJade,
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor: context.sacredJade,
              child: Text(
                community.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${community.memoryCount} memorias',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textSecondary,
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
}
