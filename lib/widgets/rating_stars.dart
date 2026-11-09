import 'package:flutter/material.dart';

import 'package:gameshelf/theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.onChanged,
  });

  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;
        final filled = value <= rating;
        final star = Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: filled ? AppColors.star : AppColors.outline,
        );

        if (onChanged == null) return star;

        return IconButton(
          tooltip: 'Beri rating $value dari 5',
          onPressed: () => onChanged(value == rating ? 0 : value),
          icon: star,
        );
      }),
    );
  }
}
