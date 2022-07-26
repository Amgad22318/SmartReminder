import 'package:flutter/material.dart';
import 'package:algoriza_task_2_todo_app_75/presentation/screens/splash/splash_screen.dart';
import 'package:algoriza_task_2_todo_app_75/constants/screens.dart' as screens;

import '../screens/home/home_layout.dart';

class AppRouter {
  late Widget startScreen;

  Route? onGenerateRoute(RouteSettings settings) {
    startScreen = const SplashScreen();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => startScreen);
      case screens.HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      default:
        return null;
    }
  }
}
