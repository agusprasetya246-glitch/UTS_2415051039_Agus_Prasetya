import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/screens/backlog_screen.dart';
import 'package:gameshelf/screens/catalog_screen.dart';
import 'package:gameshelf/screens/home_screen.dart';
import 'package:gameshelf/screens/profile_screen.dart';
import 'package:gameshelf/providers/navigation_provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;
  final _pagesKey = GlobalKey();

  void _selectTab(int index) {
    context.read<NavigationProvider>().select(index);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationProvider>().index;
    final pages = IndexedStack(
      key: _pagesKey,
      index: selectedIndex,
      children: [
        HomeScreen(onOpenTab: _selectTab),
        const CatalogScreen(),
        const BacklogScreen(),
        const ProfileScreen(),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Expanded (≥ 840): NavigationRail di kiri
        if (Breakpoints.isExpanded(constraints.maxWidth)) {
          final colorScheme = Theme.of(context).colorScheme;

          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: _selectTab,
                    labelType: NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.sports_esports,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.sports_esports_outlined),
                        selectedIcon: Icon(Icons.sports_esports),
                        label: Text('Katalog'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bookmark_border),
                        selectedIcon: Icon(Icons.bookmark),
                        label: Text('Backlog'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profil'),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: pages),
              ],
            ),
          );
        }

        return Scaffold(
          body: pages,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.sports_esports_outlined),
                selectedIcon: Icon(Icons.sports_esports),
                label: 'Katalog',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Backlog',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
