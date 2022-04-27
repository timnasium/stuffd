import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stuffd/category/category.dart';
import 'package:stuffd/export_import/export.dart';
import 'package:stuffd/location/location.dart';
import 'package:stuffd/thing/thing.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager {
  static final _dbName = "stuff.db";
  // Use this class as a singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Instantiate the database only when it's not been initialized yet.
    _database = await _initDatabase();
    return _database!;
  }

  // Creates and opens the database.
  _initDatabase() async {
    sqfliteFfiInit();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    if (!await documentsDirectory.exists()) {
      await documentsDirectory.create(recursive: true);
    }
    String path = join(documentsDirectory.path, _dbName);
    var databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate));
  }

  // Creates the database structure
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS locations(id INTEGER PRIMARY KEY, name TEXT, description TEXT)''',
    );

    await db.execute(
      '''CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY, name TEXT, matches TEXT)''',
    );

    await db.execute(
      '''CREATE TABLE IF NOT EXISTS things(id INTEGER PRIMARY KEY,
       name TEXT,
       normalName TEXT,
       description TEXT,
       brand TEXT,
       ean TEXT,
       upc TEXT,
       imageUrl TEXT,
       dateAdded DATETIME,
       locationId INTEGER,
       categoryId INTEGER
       ) ''',
    );
  }

  Future<List<Thing>> getThings({String? q, String orderby = "name"}) async {
    Database database = _database!;
    List<Map<String, dynamic>> maps;

    if (q == null)
      maps = await database.query('things', orderBy: orderby);
    else {
      maps = await database.query('things',
          where: 'name like ?', whereArgs: ['%$q%'], orderBy: orderby);
    }

    if (maps.isNotEmpty) {
      return maps.map((map) => Thing.fromDbMap(map)).toList();
    }

    return new List.empty();
  }

  Future<int> addThing(Thing thing) async {
    // Get a reference to the database.
    Database db = _database!;

    // In this case, replace any previous data.
    return db.insert(
      'things',
      thing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateThing(Thing thing) async {
    Database db = _database!;
    return db.update(
      'things',
      thing.toMap(),
      where: 'id = ?',
      whereArgs: [thing.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteThing(int id) async {
    Database db = _database!;
    return db.delete(
      'things',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Location>> getLocations(
      {String? q, String orderby = "name"}) async {
    Database database = _database!;
    List<Map<String, dynamic>> maps;

    if (q == null)
      maps = await database.query('locations', orderBy: orderby);
    else {
      maps = await database.query('locations',
          where: 'name like ?', whereArgs: ['%$q%'], orderBy: orderby);
    }

    if (maps.isNotEmpty) {
      return maps.map((map) => Location.fromDbMap(map)).toList();
    }

    return new List.empty();
  }

  Future<int> addLocation(Location location) async {
    // Get a reference to the database.
    Database db = _database!;

    // In this case, replace any previous data.
    return db.insert(
      'locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateLocation(Location location) async {
    Database db = _database!;
    return db.update(
      'locations',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteLocation(int id) async {
    Database db = _database!;
    return db.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getCategories(
      {String? q, String orderby = "name"}) async {
    Database database = _database!;
    List<Map<String, dynamic>> maps;

    if (q == null)
      maps = await database.query('categories', orderBy: orderby);
    else {
      maps = await database.query('categories',
          where: 'name like ?', whereArgs: ['%$q%'], orderBy: orderby);
    }

    if (maps.isNotEmpty) {
      return maps.map((map) => Category.fromDbMap(map)).toList();
    } else if (q == null) {
      await fillCategories();
      return getCategories();
    }

    return new List.empty();
  }

  Future<List<Category>> getCategoriesByType(String cat) async {
    Database database = _database!;
    List<Map<String, dynamic>> maps;
    maps = await database
        .query('categories', where: 'matches like ?', whereArgs: ['%$cat%']);

    if (maps.isNotEmpty) {
      return maps.map((map) => Category.fromDbMap(map)).toList();
    }

    return new List.empty();
  }

  Future<int> addCategory(Category category) async {
    // Get a reference to the database.
    Database db = _database!;

    // In this case, replace any previous data.
    return db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCategory(Category category) async {
    Database db = _database!;
    return db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCategory(int id) async {
    Database db = _database!;
    return db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> fillCategories() async {
    await addCategory(Category(
        id: 0, name: "Video Games", matches: "Software > Video Game Software"));
    await addCategory(Category(id: 0, name: "Books", matches: "Media > Books"));
    await addCategory(Category(
        id: 0,
        name: "Movies",
        matches:
            "Electronics > Video > Video Players & Recorders > DVD & Blu-ray Players|Media > DVDs & Videos"));
    await addCategory(Category(
        id: 0,
        name: "Music",
        matches: "Media > Music & Sound Recordings > Music CDs|Electronics"));
  }

  Future<List<ExportItem>> getExport() async {
    Database database = _database!;
    List<Map<String, dynamic>> maps;

    maps = await database.rawQuery('''
SELECT 
		things.id,
      things.name,
      normalName,
      things.description,
      brand,
      ean,
      upc,
      imageUrl,
      dateAdded,
      locationId,
      IFNULL(locations.name,'') as locationName,
      categoryId,
      IFNULL(categories.name,'')  AS categoryName
FROM things
LEFT OUTER JOIN locations ON things.locationId = locations.id
LEFT OUTER JOIN categories ON things.categoryId = categories.id
''');

    if (maps.isNotEmpty) {
      return maps.map((map) => ExportItem.fromDbMap(map)).toList();
    }

    return new List.empty();
  }
}
