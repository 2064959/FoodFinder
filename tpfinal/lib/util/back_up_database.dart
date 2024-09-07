import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';

class MyGroceries with ChangeNotifier {
  late final _dbPath;
  late final _dbName;
  late final Future<Database> _database;

  MyGroceries() {
    _database = _init();
  }

  Future<Database> _init() async {
    // Recupere le chemin pour la base de donnee
    _dbPath = await getDatabasesPath();

    // Cree une reference sur notre base de donnee
    _dbName = path.join(_dbPath, "myGrocerise.db");

    print("Managing DV $_dbName");

    final _newdatabase = openDatabase(
      _dbName,
      version: 1,
      onCreate: (db, version) {
        print("Creating DB");
        print("Got a call for version $version");
        return db.execute(
            "CREATE TABLE groceries (id TEXT PRIMARY KEY , name TEXT, createBy TEXT, icon TEXT)");
      },
    );

    return _newdatabase;
  }

  Future<void> insertGrocery(Grocery grocery) async {
    final db = await _database;
    await db.insert(
      'groceries',
      grocery.toMapBd(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> supprimeTache(String? id) async {
    final db = await _database;
    await db.update('groceries', {'deleted': 'true', 'complete': 'false'},
        where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<List<Grocery>> groceries() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('groceries');
    return List.generate(maps.length, (i) {
      Grocery grocery = Grocery(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['createBy'],
        maps[i]['icon'],
        [],
      );
      grocery.id = maps[i]['id'];
      return grocery;
    });
  }

  Future<List<Grocery>> tachesSupprimer() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('groceries', where: 'deleted = ?', whereArgs: ['true']);

    return List.generate(maps.length, (i) {
      Grocery grocery = Grocery(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['createBy'],
        maps[i]['icon'],
        [],
      );
      return grocery;
    });
  }

  Future<void> recupereGrocery(String? id) async {
    final db = await _database;
    await db.update('groceries', {'deleted': 'false'},
        where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  get database {
    return _database;
  }

  addGrocery(String id, String name, String createBy, String icon) {
    insertGrocery(Grocery(id, name, createBy, icon, []));
    notifyListeners();
  }

}


class MyItemss with ChangeNotifier {
  late final _dbPath;
  late final _dbName;
  late final Future<Database> _database;

  MyGroceries() {
    _database = _init();
  }

  Future<Database> _init() async {
    // Recupere le chemin pour la base de donnee
    _dbPath = await getDatabasesPath();

    // Cree une reference sur notre base de donnee
    _dbName = path.join(_dbPath, "myItems.db");

    print("Managing DV $_dbName");

    final _newdatabase = openDatabase(
      _dbName,
      version: 1,
      onCreate: (db, version) {
        print("Creating DB");
        print("Got a call for version $version");
        return db.execute(
            "CREATE TABLE items (id TEXT PRIMARY KEY , grocerieId TEXT, name TEXT, category TEXT, image TEXT, info TEXT)");
      },
    );

    return _newdatabase;
  }

  Future<void> insertItem(Article article) async {
    final db = await _database;
    await db.insert(
      'items',
      article.toMapBd(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> supprimeItem(String? id) async {
    final db = await _database;
    await db.update('items', {'deleted': 'true', 'complete': 'false'},
        where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<List<Article>> taches() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: 'deleted = ?', whereArgs: ['false']);
    return List.generate(maps.length, (i) {
      Article article = Article(
        id:maps[i]['id'],
        nom:maps[i]['name'],
        categorie:maps[i]['category'],
        image:maps[i]['image'],
        informationNutritive:maps[i]['info'],
      );
      article.groceryId = maps[i]['groceryId'];
      return article;
    });
  }

  Future<void> recupereGrocery(String? id) async {
    final db = await _database;
    await db.update('items', {'deleted': 'false'},
        where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  get database {
    return _database;
  }

  addGrocery( String id, String name, String category, String image, Map<String,dynamic> info) {
    insertItem(Article(id:id, nom:name, categorie:category, image:image, informationNutritive: Nutiments.fromMap(info)));
    notifyListeners();
  }

}
