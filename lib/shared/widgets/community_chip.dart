import 'package:flutter/material.dart';
import '../theme/theme_colors_extension.dart';

class CommunityChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CommunityChip({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? context.maizeGold : context.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? context.maizeGold : context.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 12,
            color: context.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white
                  : context.textBody,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
