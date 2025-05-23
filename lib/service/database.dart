import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:bus_tracking/dao/student_dao.dart';
import 'package:bus_tracking/models/model.dart';
import 'package:floor/floor.dart';
part 'database.g.dart';

@Database(version: 6, entities: [Student])
abstract class AppDatabase extends FloorDatabase {
  StudentDao get studentDao;
}
