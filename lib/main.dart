import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/game_provider.dart';
import 'package:gameshelf/repositories/backlog_repository.dart';
import 'package:gameshelf/repositories/game_repository.dart';
import 'package:gameshelf/screens/main_shell.dart';
import 'package:gameshelf/theme/app_theme.dart';
import 'package:gameshelf/services/free_to_game_api_service.dart';

void main() {
  runApp(const GameShelfApp());
}

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FreeToGameApiService()),
        Provider(
          create: (context) =>
              GameRepository(context.read<FreeToGameApiService>()),
        ),
        Provider(create: (context) => BacklogRepository()),

        ChangeNotifierProvider(
          create: (context) => GameProvider(context.read<GameRepository>())
            ..loadGames()
            ..loadPopular(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              BacklogProvider(context.read<BacklogRepository>())..loadBacklog(),
        ),
      ],
      child: MaterialApp(
        title: AppInfo.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MainShell(),
      ),
    );
  }
}
