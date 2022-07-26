import 'dart:async';

import 'package:algoriza_task_2_todo_app_75/constants/screens.dart' as screens;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../styles/colors.dart';
import '../../widgets/default_rich_text.dart';
import '../../widgets/default_text_span.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(screens.HOME_SCREEN, (route) => false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultAppWhiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FadeTransition(
                  opacity: _animation,
                  child: Icon(
                    Icons.alarm_outlined,
                    size: 75.sp,
                    color: defaultAppColor,
                  )),
            ),
            Flexible(
                child: DefaultRichText(
                    text: defaultTextSpan(children: [
              defaultTextSpan(text: 'S', color: defaultAppColor2),
              defaultTextSpan(text: 'mart', color: defaultAppColor),
              defaultTextSpan(text: 'R', color: defaultAppColor2),
              defaultTextSpan(text: 'eminder', color: defaultAppColor),
            ]))),
          ],
        ),
      ),
    );
  }
}
