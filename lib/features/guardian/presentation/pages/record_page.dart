import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';

class RecordMemoryPage extends StatefulWidget {
  const RecordMemoryPage({super.key});

  @override
  State<RecordMemoryPage> createState() => _RecordMemoryPageState();
}

class _RecordMemoryPageState extends State<RecordMemoryPage> {
  String? _selectedStoryType;
  String? _selectedCategory;

  final List<String> _storyTypes = [
    'Una leyenda local',
    'Un personaje histórico',
    'Una tradición familiar',
    'Un ritual',
    'Otro...',
  ];

  final List<_CategoryInfo> _categories = [
    const _CategoryInfo('Leyenda', Icons.eco, AppColors.categoryLeyenda),
    const _CategoryInfo('Historia', Icons.account_balance, AppColors.categoryHistoria),
    const _CategoryInfo('Ritual', Icons.auto_awesome, AppColors.categoryRitual),
    const _CategoryInfo('Canción', Icons.library_music, AppColors.categoryCancion),
    const _CategoryInfo('Personaje', Icons.person, AppColors.categoryPersonaje),
    const _CategoryInfo('Tradición', Icons.agriculture, AppColors.categoryTradicion),
  ];

  @override
  Widget build(BuildContext context) {
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
          'Guardar una Memoria',
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
            Text(
              '¿Qué historia quieres contar?',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: context.maizeGold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _storyTypes.map((type) {
                final isSelected = _selectedStoryType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStoryType = isSelected ? null : type;
                    });
                  },
                  child: _buildStoryChip(context, type, isSelected),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Selecciona una categoría',
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
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat.label;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : cat.label;
                    });
                  },
                  child: _buildCategoryCard(
                    context,
                    cat.icon,
                    cat.label,
                    isSelected,
                    cat.color,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedCategory != null) {
                        context.push('/preview', extra: {
                          'category': _selectedCategory,
                          'type': _selectedStoryType,
                        });
                      }
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.sacredJade,
                        boxShadow: [
                          BoxShadow(
                            color: context.sacredJade.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.mic, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Toca para grabar',
                    style: TextStyle(
                      color: context.textBody,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInactiveWaveform(context),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 13,
                      ),
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

  Widget _buildStoryChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.sacredJade : context.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? context.sacredJade : context.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isSelected ? Colors.white : context.textBody,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    Color badgeColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? badgeColor : context.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? badgeColor : context.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.white : context.textSecondary,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : context.textBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveWaveform(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        12,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: context.textSecondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _CategoryInfo {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryInfo(this.label, this.icon, this.color);
}
