import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class Provider {
  Database db;

  Future open();
}

abstract class Model {
  int id;

  Map<String, dynamic> toMap();

  Model fromMap(Map<String, dynamic> map);

  static const TABLE_NAME = '';

  String getTableName();

  List<String> getColumns();

  Future<List<Model>> filter(
      {List<String> columns,
      Map<String, dynamic> where,
      Provider provider}) async {
    List<Map> maps = await provider.db.query(getTableName(),
        columns: getColumns(),
        where: where != null
            ? where.keys.map((f) => '$f = ?').toList().join(' AND ')
            : null,
        whereArgs: where != null ? where.values.toList() : null);
    if (maps.length > 0) {
      return maps.map((m) => fromMap(m)).toList();
    }
    return <Model>[];
  }

  Future<Model> select(
      {List<String> columns,
      Map<String, dynamic> where,
      Provider provider}) async {
    List<Map> maps = await provider.db.query(getTableName(),
        columns: getColumns(),
        where: where.keys.map((f) => '$f = ?').toList().join(' AND '),
        whereArgs: where.values.toList());
    print(maps);
    if (maps.length > 0) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<Model> insert({Model model, Provider provider}) async {
    model.id = await provider.db.insert(getTableName(), model.toMap());
    return model;
  }

  Future<int> sum({String columnName, Provider provider}) async {
    var result = await provider.db
        .rawQuery('SELECT SUM($columnName) FROM ${getTableName()};');
    print('Result of sum is: $result');
    return 0;
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
  String _databaseName = 'sesat.db';
  int _databaseVersion = 2;
  Database db;

  Future<bool> open() async {
    // if (! await checkWithRequestPermission(PermissionGroup.storage)) {
    //   return false;
    // }
    String path = join(await getDatabasesPath(), _databaseName);
    print(path);
    db = await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      print('Creating database...');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${Category.TABLE_NAME} (
          ${Category.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Category.NAME_COLUMN} STRING UNIQUE,
          ${Category.DESCRIPTION_COLUMN} STRING
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${Expense.TABLE_NAME} (
          ${Expense.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Expense.PRICE_COLUMN} INTEGER NOT NULL,
          ${Expense.PRODUCT_SERVICE_COLUMN} STRING,
          ${Expense.PURCHASE_DATE_COLUMN} STRING,
          ${Expense.CATEGORY_COLUMN} INTEGER DEFAULT 1,
          CONSTRAINT fk_category
          FOREIGN KEY (${Expense.CATEGORY_COLUMN})
          REFERENCES ${Category.TABLE_NAME}(${Category.ID_COLUMN})
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${Expense.TABLE_NAME} (
          ${Expense.ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Expense.PRICE_COLUMN} INTEGER NOT NULL,
          ${Expense.PRODUCT_SERVICE_COLUMN} STRING,
          ${Expense.CATEGORY_COLUMN} INTEGER DEFAULT 1,
          CONSTRAINT fk_category
          FOREIGN KEY (${Expense.CATEGORY_COLUMN})
          REFERENCES ${Category.TABLE_NAME}(${Category.ID_COLUMN})
        )
      ''');
    });
    var result = await Category().select(
      where: {Category.NAME_COLUMN: misc.name},
      provider: this,
    );
    print('result: $result');
    if (result == null) {
      Category().insert(model: misc, provider: this);
    }
    return true;
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
  static const String PRODUCT_SERVICE_COLUMN = 'product_service';
  static const String CATEGORY_COLUMN = 'category_id';

  String getTableName() => TABLE_NAME;

  List<String> getColumns() => [
        ID_COLUMN,
        PRICE_COLUMN,
        PURCHASE_DATE_COLUMN,
        PRODUCT_SERVICE_COLUMN,
        CATEGORY_COLUMN
      ];

  Expense fromMap(Map<String, dynamic> map) {
    Expense expense = Expense();
    expense.id = map[ID_COLUMN];
    expense.price = map[PRICE_COLUMN];
    expense.purchaseDate = DateTime.parse(map[PURCHASE_DATE_COLUMN]);
    expense.productService = map[PRODUCT_SERVICE_COLUMN];
    expense.categoryId = map[CATEGORY_COLUMN];
    return expense;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      PRICE_COLUMN: price,
      PURCHASE_DATE_COLUMN: purchaseDate,
      PRODUCT_SERVICE_COLUMN: productService,
      CATEGORY_COLUMN: categoryId
    };
    if (id != null) {
      map[ID_COLUMN] = id;
    }
    return map;
  }

  String formatPrice() => '₱' + (price / 100).toString();

  int getSum() {}
}

class Category extends Model {
  String name;
  String description;

  static const String TABLE_NAME = 'category';
  static const String ID_COLUMN = 'id';
  static const String NAME_COLUMN = 'name';
  static const String DESCRIPTION_COLUMN = 'description';

  String getTableName() => TABLE_NAME;

  List<String> getColumns() => [ID_COLUMN, NAME_COLUMN, DESCRIPTION_COLUMN];

  bool operator ==(other) {
    if (other.runtimeType != Category) return false;
    other = other as Category;
    return this.name == other.name && this.description == other.description;
  }

  Category fromMap(Map<String, dynamic> map) {
    Category category = Category();
    category.id = map[ID_COLUMN];
    category.name = map[NAME_COLUMN];
    category.description = map[DESCRIPTION_COLUMN];
    return category;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      NAME_COLUMN: name,
      DESCRIPTION_COLUMN: description,
    };
    if (id != null) {
      map[ID_COLUMN] = id;
    }
    return map;
  }
}

final Category misc = Category().fromMap({
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

  List<String> getColumns() =>
      [ID_COLUMN, PRICE_COLUMN, PRODUCT_SERIVCE_COLUMN, CATEGORY_COLUMN];

  Wish fromMap(Map<String, dynamic> map) {
    Wish wish = Wish();
    wish.id = map[ID_COLUMN];
    wish.price = map[PRICE_COLUMN];
    wish.productService = map[PRODUCT_SERIVCE_COLUMN];
    wish.categoryId = map[CATEGORY_COLUMN];
    return wish;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
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
