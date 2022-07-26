import 'package:algoriza_task_2_todo_app_75/constants/local_notifications.dart';
import 'package:algoriza_task_2_todo_app_75/presentation/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'business_logic/cubit/cubit.dart';
import 'package:timezone/data/latest.dart' as timezone;

import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  NotificationService().requestIOSPermissions();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    setState(() {
      timezone.initializeTimeZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocProvider(
          create: (context) => ToDoAppCubit()..createDatabase(),
          child: MaterialApp(
            theme: lightTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}
