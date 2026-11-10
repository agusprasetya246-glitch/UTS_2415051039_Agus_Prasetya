import 'package:flutter/material.dart';

import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/status_badge.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.title,
    required this.genre,
    required this.platform,
    this.thumbnailUrl,
    this.status,
    this.onTap,
  });

  final String title;
  final String genre;
  final String platform;
  final String? thumbnailUrl;
  final BacklogStatus? status;
  final VoidCallback? onTap;

  static const EdgeInsets _textPadding = EdgeInsets.fromLTRB(12, 10, 12, 12);
  static const double _textGap = 4;

  static TextStyle? _titleStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall
          ?.copyWith(fontWeight: FontWeight.w600);

  static TextStyle? _metaStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  static double heightFor(BuildContext context, double width) {
    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);

    double lineHeight(TextStyle? style) {
      final painter = TextPainter(
        text: TextSpan(text: 'Ag', style: style),
        maxLines: 1,
        textDirection: direction,
        textScaler: textScaler,
      )..layout();
      final height = painter.height;
      painter.dispose();
      return height;
    }

    return width * 9 / 16 +
        _textPadding.vertical +
        lineHeight(_titleStyle(context)) +
        _textGap +
        lineHeight(_metaStyle(context)) +
        2;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeStatus = status;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                GameThumbnail(
                  title: title,
                  imageUrl: thumbnailUrl,
                  borderRadius: 0,
                ),
                if (badgeStatus != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: StatusBadge(status: badgeStatus, small: true),
                  ),
              ],
            ),
            Padding(
              padding: _textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _titleStyle(context),
                  ),
                  const SizedBox(height: _textGap),
                  Text(
                    '$genre · $platform',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _metaStyle(context)
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
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
