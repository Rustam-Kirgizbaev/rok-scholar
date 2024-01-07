import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show ByteData, rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:rok_scholar/database/question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;
  static const String newDbName = 'database_v1_0_0.db'; // New DB name
  static const String oldDbName =
      'database.db'; // Update this when changing the db

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final newPath = join(dbPath, newDbName);
    final oldPath = join(dbPath, oldDbName);

    // Check if old database file exists
    if (await File(oldPath).exists()) {
      // Delete the old database
      await deleteDatabase(oldPath);
    }

    // Check if the database exists
    var exists = await databaseExists(newPath);
    if (!exists) {
      // Ensure the parent directory exists
      try {
        await Directory(dirname(newPath)).create(recursive: true);
      } catch (_) {}

      // Copy from assets
      ByteData data = await rootBundle.load(join('assets', newDbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes
      await File(newPath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(newPath);
  }

  Future<bool> getSearchOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('searchOption') ?? false;
  }

  Future<List<Question>> getQuestions(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return [];
    }

    bool advancedSearchEnabled = await getSearchOption();

    // Use the LIKE operator to search for questions containing the searchTerm
    if (advancedSearchEnabled) {
      return advancedSearch(searchTerm);
    } else {
      return simpleSearch(searchTerm);
    }
  }

  Future<List<Question>> simpleSearch(String searchTerm) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps;

    // Use the LIKE operator to search for questions containing the searchTerm
    maps = await db.query('Question',
        where: 'question LIKE ?', whereArgs: ['%$searchTerm%'], limit: 10);

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<List<Question>> advancedSearch(String searchTerm) async {
    Database db = await database;
    String pattern = searchTerm
        .split(' ')
        .map((word) => "question LIKE '%$word%'")
        .join(' AND ');
    List<Map<String, dynamic>> maps = await db.query(
      'Question',
      where: pattern,
    );

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Question.fromMap(maps[i]);
      });
    }

    pattern = searchTerm
        .split(' ')
        .map((word) => "question LIKE '%$word%'")
        .join(' OR ');
    maps = await db.query(
      'Question',
      where: pattern,
    );

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<void> toggleBookmark(Question question) async {
    Database db = await database;
    // logic to toggle
    await db.update(
      'Question',
      {'bookmarked': question.bookmarked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<List<Question>> getBookmarks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps;

    // Use the LIKE operator to search for questions containing the searchTerm
    maps = await db.query('Question', where: 'bookmarked = 1');

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<List<Question>> getRandom4Question() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps;
    final List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT COUNT(*) FROM Question');
    dynamic count = res[0].values.first;
    Set<int> randomIds = {};
    Random random = Random();
    while (randomIds.length < 4) {
      randomIds.add(1 + random.nextInt(count - 1));
    }

    String pattern = randomIds.map((id) => "id = $id").join(' OR ');
    maps = await db.query(
      'Question',
      where: pattern,
    );

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }
}
