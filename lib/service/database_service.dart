import 'package:bus_tracking/service/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static AppDatabase? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<AppDatabase> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<AppDatabase> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'school_bus.db');
    final database = await $FloorAppDatabase.databaseBuilder(path).build();
    return database;
  }

  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }
}
