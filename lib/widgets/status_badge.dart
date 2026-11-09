import 'package:flutter/material.dart';

import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.small = false});

  final BacklogStatus status;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color foreground;
    final Color background;

    switch (status) {
      case BacklogStatus.wantToPlay:
        icon = Icons.bookmark_border_rounded;
        foreground = AppColors.wantToPlay;
        background = AppColors.wantToPlayBg;
      case BacklogStatus.playing:
        icon = Icons.play_arrow_rounded;
        foreground = AppColors.playing;
        background = AppColors.playingBg;
      case BacklogStatus.done:
        icon = Icons.check_rounded;
        foreground = AppColors.done;
        background = AppColors.doneBg;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 12 : 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: foreground,
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
