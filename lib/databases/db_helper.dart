import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prediction_result.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'predictions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE predictions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            label TEXT,
            confidence REAL,
            moisture REAL,
            imagePath TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertPrediction(PredictionResult result) async {
    final db = await database;
    return await db.insert('predictions', result.toMap());
  }

  Future<List<PredictionResult>> getPredictions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('predictions', orderBy: 'id DESC');
    return maps.map((map) => PredictionResult.fromMap(map)).toList();
  }
}