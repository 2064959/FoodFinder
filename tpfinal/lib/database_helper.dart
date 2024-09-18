import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:tpfinal/model/user.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'user_database.db');

    // Open the database and create the users and popularProduct tables if they don't exist.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create users table
        await db.execute(
          'CREATE TABLE users(uid TEXT PRIMARY KEY, email TEXT, username TEXT)',
        );

        // Create popularProduct table
        await db.execute(
          'CREATE TABLE popularProduct(barcode TEXT PRIMARY KEY, productName TEXT, brands TEXT, quantity TEXT,categoriesTags TEXT, nutriments TEXT, imageFrontUrl TEXT)',
        );
      },
    );
  }

  // ---------------- User-related methods ----------------

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null; // No user found
    }
  }

  Future<void> deleteUser(String uid) async {
    final db = await database;
    await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
  }

  // ---------------- Product-related methods ----------------

  // Insert a popular product into the database.
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'popularProduct',
      {
        'barcode': product.barcode,
        'productName': product.productName,
        'brands': product.brands,
        'quantity': product.quantity,
        'categoriesTags': jsonEncode(product.categoriesTags),
        'nutriments': jsonEncode(product.nutriments?.toJson()),
        'imageFrontUrl': product.imageFrontUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert a list of popular products into the database.
  Future<void> insertProducts(List<Product> products) async {
    for (final product in products) {
      await insertProduct(product);
    }
  }

  // Retrieve a product from the database by its barcode.
  Future<Product?> getProduct(String barcode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'popularProduct',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (maps.isNotEmpty) {
      final productMap = maps.first;

      // Convert the map to a Product object
      return Product(
        barcode: productMap['barcode'],
        productName: productMap['productName'],
        brands: productMap['brands'],
        quantity: productMap['quantity'],
        categoriesTags: List<String>.from(jsonDecode(productMap['categoriesTags'])),
        nutriments: Nutriments.fromJson(jsonDecode(productMap['nutriments'])),
        imageFrontUrl: productMap['imageFrontUrl'],
      );
    } else {
      return null; // No product found
    }
  }

  Future<List<Product>> getPopularProducts(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'popularProduct',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      final productMap = maps[i];

      return Product(
        barcode: productMap['barcode'],
        productName: productMap['productName'],
        brands: productMap['brands'],
        quantity: productMap['quantity'],
        categoriesTags: List<String>.from(jsonDecode(productMap['categoriesTags'])),
        nutriments: Nutriments.fromJson(jsonDecode(productMap['nutriments'])),
        imageFrontUrl: productMap['imageFrontUrl'],
      );
    });
  }

  // Delete a product from the database by its barcode.
  Future<void> deleteProduct(String barcode) async {
    final db = await database;
    await db.delete('popularProduct', where: 'barcode = ?', whereArgs: [barcode]);
  }

  // Close the database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
