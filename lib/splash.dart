import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  void _navigate(context) {
    // Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _timer = new Timer(const Duration(seconds: 2), () {
        _navigate(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipOval(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black)]),
                  child: Hero(
                    tag: 'logo',
                    child: SvgPicture.asset('images/logo.svg',
                        semanticsLabel: 'App Logo'),
                  )),
            ),
            Text('Sesat',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 2.0,
                        color: Colors.black)
                  ],
                  fontFamily: 'Habibi',
                  fontSize: 48.0,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
