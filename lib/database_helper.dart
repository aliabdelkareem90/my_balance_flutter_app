import 'dart:io';
import 'package:my_balance_app/transection_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// import 'transection_model.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._();

  // Database instance
  static Database? _database;

  // Private constructor
  DatabaseHelper._();

  // Get the singleton instance
  factory DatabaseHelper() => _instance;

  // Get the database instance, or create it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the database path
    final String path = join(await getDatabasesPath(), 'items.db');

    // Open and return the database
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Create the database table
  Future<void> _createDatabase(Database db, int version) async {
    // Execute the SQL statement to create the table
    await db.execute('''
      CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER not null, date TEXT, color INTEGER)
      ''');
  }

  // Insert an item into the database
  Future<void> insertItem(Item item) async {
    // Get the database instance
    final Database db = await database;

    // Insert the item and get the id
    final int id = await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update the item id
    item.id = id;
  }

  // Get all the items from the database
  Future<List<Item>> getItems() async {
    // Get the database instance
    final Database db = await database;

    // Query the database and get the maps
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      orderBy: 'date DESC',
    );

    // Convert the maps to item objects and return them
    return List.generate(maps.length, (index) => Item.fromMap(maps[index]));
  }

  Future getSum() async {
    final Database db = await database;
    var result = await db.rawQuery('SELECT SUM(amount) AS TOTAL FROM items');
    return result.toList();
  }

  // Update an item in the database
  Future<void> updateItem(Item item) async {
    // Get the database instance
    final Database db = await database;

    // Update the item
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Delete an item from the database
  Future<void> deleteItem(Item item) async {
    // Get the database instance
    final Database db = await database;

    // Delete the item
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
