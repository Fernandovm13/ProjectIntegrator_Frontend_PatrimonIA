import 'dart:math';
import 'package:flutter/material.dart';

class RecordMemoryPage extends StatefulWidget {
  const RecordMemoryPage({super.key});

  @override
  State<RecordMemoryPage> createState() => _RecordMemoryPageState();
}

class _RecordMemoryPageState extends State<RecordMemoryPage> {
  String? _selectedStoryType;
  String _selectedCategory = 'Leyenda';

  final List<String> _storyTypes = const [
    'Una leyenda local',
    'Un personaje histórico',
    'Una tradición familiar',
    'Un ritual',
    'Otro...',
  ];

  static const List<_CategoryInfo> _categories = [
    _CategoryInfo('Leyenda', '📜'),
    _CategoryInfo('Historia', '🏛️'),
    _CategoryInfo('Ritual', '🥁'),
    _CategoryInfo('Canción', '🎵'),
    _CategoryInfo('Personaje', '👤'),
    _CategoryInfo('Tradición', '🌽'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSuggestionsBox(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context),
            const SizedBox(height: 12),
            _buildCategoryGrid(context),
            const SizedBox(height: 32),
            _buildRecordingSection(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Guardar una Memoria',
        style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSuggestionsBox(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.tertiary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué historia quieres contar?',
            style: tt.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _storyTypes.map((type) {
              final isSelected = _selectedStoryType == type;
              return _buildStoryChip(context, type, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryChip(BuildContext context, String label, bool isSelected) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedStoryType = isSelected ? null : label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Text(
      'Selecciona una categoría',
      style: tt.bodyMedium,
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat.label;
        return _buildCategoryCard(context, cat, isSelected);
      }).toList(),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, _CategoryInfo cat, bool isSelected) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = cat.label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.onSurfaceVariant.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cat.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              cat.label,
              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          _buildRadarButton(context),
          const SizedBox(height: 16),
          Text(
            'Toca para grabar',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _buildWaveform(context),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: tt.bodySmall?.copyWith(
                decoration: TextDecoration.underline,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary,
              ),
              child: Icon(Icons.mic, color: cs.onPrimary, size: 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final random = Random(42);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        14,
        (index) {
          final height = 4.0 + random.nextDouble() * 8.0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 2,
              height: height,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryInfo {
  final String label;
  final String emoji;

  const _CategoryInfo(this.label, this.emoji);
}
