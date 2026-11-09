import 'package:flutter/material.dart';

import 'package:gameshelf/theme/app_colors.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/status_badge.dart';

class BacklogTile extends StatelessWidget {
  const BacklogTile({
    super.key,
    required this.title,
    required this.status,
    required this.rating,
    required this.hoursPlayed,
    required this.addedLabel,
    this.thumbnailUrl,
    this.onTap,
    this.onDelete,
  });

  final String title;
  final String status;
  final int rating;
  final int hoursPlayed;
  final String addedLabel;
  final String? thumbnailUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mutedSmall = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                child: GameThumbnail(
                  title: title,
                  imageUrl: thumbnailUrl,
                  borderRadius: 8,
                  initialsSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusBadge(status: status, small: true),
                        if (rating > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: AppColors.star,
                              ),
                              const SizedBox(width: 2),
                              Text('$rating/5', style: mutedSmall),
                            ],
                          )
                        else
                          Text('Belum dinilai', style: mutedSmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$hoursPlayed jam main · $addedLabel',
                      style: mutedSmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus $title dari backlog',
                onPressed: onDelete ?? () {},
                icon: Icon(
                  Icons.delete_outline,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
