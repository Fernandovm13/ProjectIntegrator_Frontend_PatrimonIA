import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WaveformWidget extends StatelessWidget {
  final int barCount;
  final Color color;

  const WaveformWidget({
    super.key,
    this.barCount = 20,
    this.color = AppColors.maizeGold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        barCount,
        (index) => Container(
          width: 4,
          height: (index % 3 == 0) ? 40 : (index % 2 == 0) ? 20 : 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
