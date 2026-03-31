import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:tpfinal/model/liked_products.dart';
import 'package:tpfinal/model/user.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const String tableUsers = 'users';
  static const String tablePopularProducts = 'popularProduct';
  static const String tableLikedProducts = 'likedProducts';

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

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableUsers(uid TEXT NOT NULL PRIMARY KEY, email TEXT, username TEXT)',
        );

        await db.execute(
          'CREATE TABLE $tablePopularProducts(barcode TEXT NOT NULL PRIMARY KEY, productName TEXT, brands TEXT, quantity TEXT, categoriesTags TEXT, nutriments TEXT, imageFrontUrl TEXT, imageFrontSmallUrl TEXT, completeness REAL, statesTags TEXT)',
        );

        await db.execute(
          '''
            CREATE TABLE $tableLikedProducts(
              likesID INTEGER PRIMARY KEY AUTOINCREMENT,
              idProduct TEXT NOT NULL,
              productName TEXT, 
              brands TEXT,
              imageFrontUrl TEXT,
              nutriments TEXT,
              whenLiked DATETIME DEFAULT CURRENT_TIMESTAMP, 
              userUid TEXT NOT NULL, 
              FOREIGN KEY (userUid) REFERENCES $tableUsers(uid) ON DELETE CASCADE
            )
          ''',
        );

        await db.execute(
          'CREATE INDEX idx_liked_user_product ON $tableLikedProducts(userUid, idProduct)'
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $tablePopularProducts ADD COLUMN imageFrontSmallUrl TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE $tablePopularProducts ADD COLUMN completeness REAL');
          await db.execute('ALTER TABLE $tablePopularProducts ADD COLUMN statesTags TEXT');
        }
      },

    );
  }

  // ---------------- User-related methods ----------------

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(tableUsers, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUserWithId(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'uid = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteUser(String uid) async {
    final db = await database;
    await db.delete(tableUsers, where: 'uid = ?', whereArgs: [uid]);
  }

  Future<bool> isUserExist(String uid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return maps.isNotEmpty;
  }

  // ---------------- Product-related methods ----------------

  Future<void> insertProduct(Product product, {double? completeness, List<String>? statesTags}) async {
    final db = await database;
    await db.insert(
      tablePopularProducts,
      {
        'barcode': product.barcode,
        'productName': product.productName,
        'brands': product.brands,
        'quantity': product.quantity,
        'categoriesTags': product.categoriesTags != null ? jsonEncode(product.categoriesTags) : null,
        'nutriments': product.nutriments != null ? jsonEncode(product.nutriments!.toJson()) : null,
        'imageFrontUrl': product.imageFrontUrl,
        'imageFrontSmallUrl': product.imageFrontSmallUrl,
        'completeness': completeness,
        'statesTags': statesTags != null ? jsonEncode(statesTags) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProducts(List<Product> products, {Map<String, double>? completenessMap, Map<String, List<String>>? statesTagsMap}) async {
    for (final product in products) {
      final completeness = completenessMap?[product.barcode!];
      final statesTags = statesTagsMap?[product.barcode!];
      await insertProduct(product, completeness: completeness, statesTags: statesTags);
    }
  }

  Future<Product?> getProduct(String barcode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePopularProducts,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (maps.isNotEmpty) {
      final productMap = maps.first;
      return _mapToProduct(productMap);
    }
    return null;
  }

  Future<List<Product>> getPopularProducts(int limit, {int offset = 0}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePopularProducts,
      limit: limit,
      offset: offset,
      orderBy: 'completeness DESC', // Highest quality first
    );

    return maps.map((m) => _mapToProduct(m)).toList();
  }

  Product _mapToProduct(Map<String, dynamic> m) {
    return Product(
      barcode: m['barcode'] ?? '',
      productName: m['productName'] ?? 'Unknown Product',
      brands: m['brands'] ?? 'Unknown Brand',
      quantity: m['quantity'],
      categoriesTags: m['categoriesTags'] != null 
          ? List<String>.from(jsonDecode(m['categoriesTags'])) 
          : null,
      nutriments: m['nutriments'] != null 
          ? Nutriments.fromJson(jsonDecode(m['nutriments'])) 
          : null,
      imageFrontUrl: m['imageFrontUrl'],
      imageFrontSmallUrl: m['imageFrontSmallUrl'],
    );
  }

  Future<void> deleteProduct(String barcode) async {
    final db = await database;
    await db.delete(tablePopularProducts, where: 'barcode = ?', whereArgs: [barcode]);
  }

  // ---------------- Liked product-related methods ----------------

  Future<void> insertLikedProduct(LikedProduct product) async {
    final db = await database;
    await db.insert(
      tableLikedProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LikedProduct?> getLikedProduct(String idProduct) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableLikedProducts,
      where: 'idProduct = ?',
      whereArgs: [idProduct],
    );

    if (maps.isNotEmpty) {
      return LikedProduct.fromMap(maps.first);
    }
    return null;
  }

  Future<List<LikedProduct>> getLikedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableLikedProducts);
    return maps.map((m) => LikedProduct.fromMap(m)).toList();
  }

  Future<void> deleteLikedProduct(String idProduct, String userUid) async {
    final db = await database;
    await db.delete(
      tableLikedProducts, 
      where: 'idProduct = ? AND userUid = ?',
      whereArgs: [idProduct, userUid],
    );
  }

  Future<bool> isProductLikedByUser(String idProduct, String userUid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableLikedProducts,
      where: 'idProduct = ? AND userUid = ?',
      whereArgs: [idProduct, userUid],
    );
    return maps.isNotEmpty;
  }

  Future<List<Product>> getLikedProductsByUser(String userUid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableLikedProducts,
      where: 'userUid = ?',
      whereArgs: [userUid],
    );

    return maps.map((m) => Product(
      barcode: m['idProduct'] ?? '',
      productName: m['productName'] ?? 'Unknown Product',
      brands: m['brands'] ?? 'Unknown Brand',
      imageFrontUrl: m['imageFrontUrl'],
      nutriments: m['nutriments'] != null 
          ? Nutriments.fromJson(jsonDecode(m['nutriments'])) 
          : null,
    )).toList();
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
