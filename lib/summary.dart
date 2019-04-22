import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'dart:math';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  var rng = Random();
  Color _trackColor;
  Color _seekColor;

  @override
  initState() {
    super.initState();
    _trackColor = generateRandomColor();
    _seekColor = generateRandomColor();
  }

  Color generateRandomColor() {
    return Color.fromARGB(
        255, rng.nextInt(255), rng.nextInt(255), rng.nextInt(255));
  }


  @override
  Widget build(BuildContext context) {

    Queue<String> _latestTransactions;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                    tag: 'logo',
                    child: SvgPicture.asset(
                      'images/logo.svg',
                      semanticsLabel: 'App Logo',
                      width: 40,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Sesat - Money Tracker',
                      style: TextStyle(fontFamily: 'Habibi', fontSize: 16.0)),
                ),
              ],
            ),
          ),
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: SizedBox(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    RadialSeekBar(
                      trackWidth: 1.0,
                    ),
                    Center(
                      child: Text(
                        '₱41,000',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text('Latest Transactions'),
            ListView(
              shrinkWrap: true,
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }
}
