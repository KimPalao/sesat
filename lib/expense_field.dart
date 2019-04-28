import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sesat/provider.dart';

class ExpenseField extends StatefulWidget {
  ExpenseField({@required this.categories});

  final Set<Category> categories;

  @override
  _ExpenseFieldState createState() => _ExpenseFieldState();
}

class _ExpenseFieldState extends State<ExpenseField> {
  DateTime _currentDate = DateTime.now();

  var _productServiceTextEditingController = TextEditingController();
  var _priceTextEditingController = TextEditingController();

  bool _showAdd = false;

  Category _chosenCategory;
  String extractDate(DateTime dateTime) {
    String str = dateTime.toString();
    return str.substring(0, str.indexOf(' '));
  }

  Future<void> addExpense() async {
    int price = int.parse(_priceTextEditingController.value.toString());
    String productService =
        _productServiceTextEditingController.value.toString();
    Category cat = _chosenCategory;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chosenCategory = widget.categories.first ?? null;
  }

  @override
  Widget build(BuildContext context) {
    var _children = <Widget>[
      TextField(
        decoration: InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
        keyboardType: TextInputType.number,
        controller: _priceTextEditingController,
      ),
      TextField(
        decoration: InputDecoration(
            labelText: 'Product/Service',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
        controller: _productServiceTextEditingController,
      ),
      DecoratedBox(
        decoration: BoxDecoration(border: Border.all()),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Category>(
            value: widget.categories.first ?? null,
            items: widget.categories
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(c.name),
                      ),
                    ))
                .toList(),
            onChanged: (chosenCategory) => _chosenCategory = chosenCategory,
            isExpanded: true,
          ),
        ),
      ),
      InkWell(
        child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all()),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(extractDate(_currentDate)),
            )),
        onTap: () async {
          print('Tapped!');
          DateTime selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate:
                  DateTime.now().subtract(Duration(seconds: 60 * 60 * 24 * 30)),
              lastDate: DateTime.now());
          setState(() {
            _currentDate = selectedDate;
          });
        },
      ),
      SizedBox(height: 10)
    ];
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Latest Transactions',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      onExpansionChanged: (showing) => setState(() {
            _showAdd = showing;
          }),
      trailing: Icon(_showAdd ? Icons.remove : Icons.add),
      children: <Widget>[
        Row(
          children: <Widget>[
            Transform.rotate(
              angle: pi / 4,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) => _children[index],
                itemCount: _children.length,
                shrinkWrap: true,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
