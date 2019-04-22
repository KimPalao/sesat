import 'dart:async';

import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability); // Request the capability to invoke methods.
}

const reflector = const Reflector();

abstract class Provider {
  Database db;
  Future open(String path);
}

@reflector
abstract class Model {
  int id;

  Map<String, dynamic> toMap();
  static Model fromMap(Map<String, dynamic> map) { return null; }

  static const TABLE_NAME = '';
  String getTableName();

  Future<List<Model>> filter(int id, List<String> columns, Map<String, dynamic> where,  Provider p, Type t) async {
    assert(t is Model);
    List<Map> maps = await p.db.query(getTableName(), columns: columns, where: where.keys.map((f) => '$f = ?').toList().join(' AND '), whereArgs: where.values);
    if (maps.length > 0) {
      return maps.map((m) => fromMap(m)).toList();
    }
    return <Model>[];
  }

  Future<Model> select(int id, List<String> columns, Map<String, dynamic> where,  Provider p) async {
    List<Map> maps = await p.db.query(getTableName(), columns: columns, where: where.keys.map((f) => '$f = ?').toList().join(' AND '), whereArgs: where.values);
    if (maps.length > 0) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<Model> insert(Model model, Provider p) async {
    model.id = await p.db.insert(getTableName(), model.toMap());
    return model;
  }

  // TODO: Implement delete
  // Future<int> delete(Provider p, {Model model, int id}) async {
  //   if (id != null) {
  //     return await p.db.delete(getTableName(), where: )
  //   } else if (model != null) {

  //   } else {
  //     throw ArgumentError;
  //   }
  // }

}


class ExpensesProvider extends Provider {
  Database db; 
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE ${Category.TABLE_NAME} (
          ${Category.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Category.NAME_COLUMN} STRING UNIQUE,
          ${Category.DESCRIPTION_COLUMN} STRING,
        )
      ''');
      await db.insert(Category.TABLE_NAME, misc.toMap());
      await db.execute('''
        CREATE TABLE ${Expense.TABLE_NAME} (
          ${Expense.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Expense.PRICE_COLUMN} INTEGER NOT NULL,
          ${Expense.PRODUCT_SERIVCE_COLUMN} STRING,
          ${Expense.PURCHASE_DATE_COLUMN} STRING,
          ${Expense.CATEGORY_COLUMN} INTEGER DEFAULT 1,
          CONSTRAINT fk_category
          FOREIGN KEY (${Expense.CATEGORY_COLUMN})
          REFERENCES ${Category.TABLE_NAME}(${Category.ID_COLUMN})
        )
      ''');
      await db.execute('''
        CREATE TABLE ${Expense.TABLE_NAME} (
          ${Expense.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Expense.PRICE_COLUMN} INTEGER NOT NULL,
          ${Expense.PRODUCT_SERIVCE_COLUMN} STRING,
          ${Expense.CATEGORY_COLUMN} INTEGER DEFAULT 1,
          CONSTRAINT fk_category
          FOREIGN KEY (${Expense.CATEGORY_COLUMN})
          REFERENCES ${Category.TABLE_NAME}(${Category.ID_COLUMN})
        )
      ''');
    });
  }

  Future<Model> insert(Model model) async {
    model.id = await db.insert(model.getTableName(), model.toMap());
    return model;
  }

}

class Expense extends Model {
  int price;
  DateTime purchaseDate;
  String productService;
  int categoryId;

  static const String TABLE_NAME = 'expenses';
  static const String ID_COLUMN = 'id';
  static const String PRICE_COLUMN = 'price';
  static const String PURCHASE_DATE_COLUMN = 'purchase_date';
  static const String PRODUCT_SERIVCE_COLUMN = 'product_service';
  static const String CATEGORY_COLUMN = 'category_id';

  String getTableName() => TABLE_NAME;

  static Expense fromMap(Map<String, dynamic> map) {
    Expense expense = Expense();
    expense.id = map[ID_COLUMN];
    expense.price = map[PRICE_COLUMN];
    expense.purchaseDate = map[PURCHASE_DATE_COLUMN];
    expense.productService = map[PRODUCT_SERIVCE_COLUMN];
    expense.categoryId = map[CATEGORY_COLUMN];
    return expense;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      PRICE_COLUMN: price,
      PURCHASE_DATE_COLUMN: purchaseDate,
      PRODUCT_SERIVCE_COLUMN: productService,
      CATEGORY_COLUMN: categoryId
    };
    if (id != null) {
      map[ID_COLUMN] = id;
    }
    return map;
  }


}


class Category extends Model {
  String name;
  String description;

  static const String TABLE_NAME = 'category';
  static const String ID_COLUMN = 'id';
  static const String NAME_COLUMN = 'name';
  static const String DESCRIPTION_COLUMN = 'description';

  String getTableName() => TABLE_NAME;

  static Category fromMap(Map<String, dynamic> map) {
    Category category = Category();
    category.id = map[ID_COLUMN];
    category.name = map[NAME_COLUMN];
    category.description = map[DESCRIPTION_COLUMN];
    return category;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      NAME_COLUMN: name,
      DESCRIPTION_COLUMN: description,
    };
    if (id != null) {
      map[ID_COLUMN] = id;
    }
    return map;
  }

}

final Category misc = Category.fromMap({
  Category.NAME_COLUMN: 'Miscellaneous',
  Category.DESCRIPTION_COLUMN: 'Uncategorized'
});

class Wish extends Model {
  String productService;
  int price;
  int categoryId;

  static const TABLE_NAME = 'wishes';
  static const String ID_COLUMN = 'id';
  static const String PRICE_COLUMN = 'price';
  static const String PRODUCT_SERIVCE_COLUMN = 'product_service';
  static const String CATEGORY_COLUMN = 'category_id';

  String getTableName() => TABLE_NAME;

  static Wish fromMap(Map<String, dynamic> map) {
    Wish wish = Wish();
    wish.id = map[ID_COLUMN];
    wish.price = map[PRICE_COLUMN];
    wish.productService = map[PRODUCT_SERIVCE_COLUMN];
    wish.categoryId = map[CATEGORY_COLUMN];
    return wish;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      PRICE_COLUMN: price,
      PRODUCT_SERIVCE_COLUMN: productService,
      CATEGORY_COLUMN: categoryId
    };
    if (id != null) {
      map[ID_COLUMN] = id;
    }
    return map;
  }

}