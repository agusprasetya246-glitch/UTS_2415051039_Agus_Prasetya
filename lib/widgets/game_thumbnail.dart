import 'package:flutter/material.dart';

class GameThumbnail extends StatelessWidget {
  const GameThumbnail({
    super.key,
    required this.title,
    this.imageUrl,
    this.borderRadius = 0,
    this.initialsSize = 22,
  });

  final String title;
  final String? imageUrl;
  final double borderRadius;
  final double initialsSize;

  static const List<Color> _tints = [
    Color(0xFF2B3A4F),
    Color(0xFF4A2F2A),
    Color(0xFF2F4433),
    Color(0xFF4A2B33),
    Color(0xFF4A4026),
    Color(0xFF2A4446),
    Color(0xFF3A3350),
    Color(0xFF4A3826),
  ];

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: (url == null || url.isEmpty)
            ? _buildPlaceholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _buildPlaceholder(),
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final index =
        title.codeUnits.fold<int>(0, (sum, c) => sum + c) % _tints.length;

    return ColoredBox(
      color: _tints[index],
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: initialsSize,
            fontWeight: FontWeight.w700,
            color: const Color(0x99E6E8EE),
          ),
        ),
      ),
    );
  }

  String get _initials {
    final words = title
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final word = words.first;
      return word.substring(0, word.length < 2 ? word.length : 2).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
