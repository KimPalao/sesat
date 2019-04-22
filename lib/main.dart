import 'package:flutter/material.dart';
import 'package:sesat/splash.dart';
import 'package:sesat/summary.dart';

void main() => runApp(SesatApp());

class SesatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFFFCF40, {
            50: Color(0xFFFFCF40),
            100: Color(0xFFFFCF40),
            200: Color(0xFFFFCF40),
            300: Color(0xFFFFCF40),
            400: Color(0xFFFFCF40),
            500: Color(0xFFFFCF40),
            600: Color(0xFFFFCF40),
            700: Color(0xFFFFCF40),
            800: Color(0xFFFFCF40), 
            900: Color(0xFFFFCF40),
          }
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => Summary(),
        '/splash': (context) => SplashScreen()
      },
    );
  }
}
