import 'package:flutter/material.dart';

import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/widgets/info_card.dart';
import 'package:gameshelf/widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final initials = AppInfo.studentName
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();
    final totalHours = dummyBacklog.fold<int>(
      0,
      (sum, item) => sum + (item['hours_played'] as int),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                    child: Text(
                      initials,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppInfo.studentName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM ${AppInfo.studentId} · Kelas ${AppInfo.studentClass}',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${AppInfo.studyProgram} · ${AppInfo.university}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '${dummyBacklog.length}',
                  label: 'Game di backlog',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(value: '$totalHours', label: 'Total jam main'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const SectionHeader(title: 'Tentang aplikasi'),
          const SizedBox(height: 12),
          const InfoCard(
            items: {
              'Aplikasi': '${AppInfo.appName} v${AppInfo.appVersion}',
              'Mata kuliah': 'Pemrograman Mobile · UTS',
              'Data katalog': 'FreeToGame API',
              'Database': 'Supabase (PostgreSQL)',
              'State management': 'Provider',
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Data game disediakan oleh FreeToGame.com',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
