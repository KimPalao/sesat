import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'package:sesat/globals.dart';
import 'package:sesat/provider.dart';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  var rng = Random();
  Color _trackColor;
  Color _seekColor;

  var _productServiceTextEditingController = TextEditingController();
  var _priceTextEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    _trackColor = generateRandomColor();
    _seekColor = generateRandomColor();
    initializeProvider();
  }

  Future<void> initializeProvider() async {
    if (!await provider.open()) {
      int result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text('Grant'),
                  onPressed: () {
                    Navigator.of(context).pop(0);
                    // initializeProvider();
                  },
                ),
                FlatButton(
                  child: Text('Exit App'),
                  onPressed: () {
                    exit(0); // Close the app
                  },
                )
              ],
            );
          });
    }
    print((await Category().select(
        where: {Category.NAME_COLUMN: 'Miscellaneous'}, provider: provider)));
  }

  Color generateRandomColor() {
    return Color.fromARGB(
        255, rng.nextInt(255), rng.nextInt(255), rng.nextInt(255));
  }

  @override
  Widget build(BuildContext context) {
    Queue<Expense> _latestTransactions = Queue.of([
      Expense().fromMap({
        Expense.PRICE_COLUMN: 14561,
        Expense.CATEGORY_COLUMN: 1,
        Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
        Expense.PRODUCT_SERVICE_COLUMN: 'Food'
      }),
      Expense().fromMap({
        Expense.PRICE_COLUMN: 25624,
        Expense.CATEGORY_COLUMN: 1,
        Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
        Expense.PRODUCT_SERVICE_COLUMN: 'Grocery'
      }),
      Expense().fromMap({
        Expense.PRICE_COLUMN: 56234,
        Expense.CATEGORY_COLUMN: 1,
        Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
        Expense.PRODUCT_SERVICE_COLUMN: 'Transportation'
      })
    ]);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Latest Transactions',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                FlatButton(
                  child: Icon(Icons.add),
                  onPressed: () {},
                )
              ],
            ),
            Row(
              children: <Widget>[
                Transform.rotate(
                  angle: pi / 4,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _productServiceTextEditingController,
                    ),
                    TextField(),
                    TextField(),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  ExpenseItem(expense: _latestTransactions.toList()[index]),
              itemCount: _latestTransactions.length,
//              children: <Widget>[
//                ExpenseItem(
//                    expense: Expense().fromMap({
//                  Expense.PRICE_COLUMN: 14561,
//                  Expense.CATEGORY_COLUMN: 1,
//                  Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
//                  Expense.PRODUCT_SERVICE_COLUMN: 'Food'
//                })),
//                ExpenseItem(
//                    expense: Expense().fromMap({
//                  Expense.PRICE_COLUMN: 25624,
//                  Expense.CATEGORY_COLUMN: 1,
//                  Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
//                  Expense.PRODUCT_SERVICE_COLUMN: 'Grocery'
//                })),
//                ExpenseItem(
//                    expense: Expense().fromMap({
//                  Expense.PRICE_COLUMN: 56234,
//                  Expense.CATEGORY_COLUMN: 1,
//                  Expense.PURCHASE_DATE_COLUMN: '2019-04-20',
//                  Expense.PRODUCT_SERVICE_COLUMN: 'Transportation'
//                })),
//              ],
            )
          ],
        ),
      ),
    );
  }
}

class ExpenseItem extends StatelessWidget {
  ExpenseItem({@required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(expense.productService),
          Text(
            expense.formatPrice(),
            style: TextStyle(fontFamily: 'Consolas'),
          )
        ],
      ),
    );
  }
}
