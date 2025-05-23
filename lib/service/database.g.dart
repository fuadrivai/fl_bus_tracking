// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StudentDao? _studentDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 6,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Students` (`childID` TEXT, `childName` TEXT, `childDivision` TEXT, `childDriver` TEXT, `mode` TEXT, `action` TEXT, PRIMARY KEY (`childID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StudentDao get studentDao {
    return _studentDaoInstance ??= _$StudentDao(database, changeListener);
  }
}

class _$StudentDao extends StudentDao {
  _$StudentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _studentInsertionAdapter = InsertionAdapter(
            database,
            'Students',
            (Student item) => <String, Object?>{
                  'childID': item.childID,
                  'childName': item.childName,
                  'childDivision': item.childDivision,
                  'childDriver': item.childDriver,
                  'mode': item.mode,
                  'action': item.action
                },
            changeListener),
        _studentUpdateAdapter = UpdateAdapter(
            database,
            'Students',
            ['childID'],
            (Student item) => <String, Object?>{
                  'childID': item.childID,
                  'childName': item.childName,
                  'childDivision': item.childDivision,
                  'childDriver': item.childDriver,
                  'mode': item.mode,
                  'action': item.action
                },
            changeListener),
        _studentDeletionAdapter = DeletionAdapter(
            database,
            'Students',
            ['childID'],
            (Student item) => <String, Object?>{
                  'childID': item.childID,
                  'childName': item.childName,
                  'childDivision': item.childDivision,
                  'childDriver': item.childDriver,
                  'mode': item.mode,
                  'action': item.action
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Student> _studentInsertionAdapter;

  final UpdateAdapter<Student> _studentUpdateAdapter;

  final DeletionAdapter<Student> _studentDeletionAdapter;

  @override
  Future<List<Student>> findAllStudent() async {
    return _queryAdapter.queryList('SELECT * FROM Students',
        mapper: (Map<String, Object?> row) => Student(
            childName: row['childName'] as String?,
            childID: row['childID'] as String?,
            childDivision: row['childDivision'] as String?,
            childDriver: row['childDriver'] as String?,
            mode: row['mode'] as String?,
            action: row['action'] as String?));
  }

  @override
  Future<List<Student>> findByAction(String action) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Students WHERE action = ?1 ORDER BY childID ASC',
        mapper: (Map<String, Object?> row) => Student(
            childName: row['childName'] as String?,
            childID: row['childID'] as String?,
            childDivision: row['childDivision'] as String?,
            childDriver: row['childDriver'] as String?,
            mode: row['mode'] as String?,
            action: row['action'] as String?),
        arguments: [action]);
  }

  @override
  Stream<Student?> findStudentById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Students WHERE childID = ?1',
        mapper: (Map<String, Object?> row) => Student(
            childName: row['childName'] as String?,
            childID: row['childID'] as String?,
            childDivision: row['childDivision'] as String?,
            childDriver: row['childDriver'] as String?,
            mode: row['mode'] as String?,
            action: row['action'] as String?),
        arguments: [id],
        queryableName: 'Students',
        isView: false);
  }

  @override
  Future<int?> updateActionStudent(
    String action,
    int id,
  ) async {
    return _queryAdapter.query(
        'UPDATE OR ABORT Students SET action = ?1 WHERE childID = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [action, id]);
  }

  @override
  Future<int?> updatePickupStudent(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.query(
        'UPDATE OR ABORT Students SET action = \"Arrived\" WHERE childID IN (' +
            _sqliteVariablesForIds +
            ')',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [...ids]);
  }

  @override
  Future<void> insertStudent(Student student) async {
    await _studentInsertionAdapter.insert(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertStudents(List<Student> students) async {
    await _studentInsertionAdapter.insertList(
        students, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _studentUpdateAdapter.update(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStudent(Student student) async {
    await _studentDeletionAdapter.delete(student);
  }

  @override
  Future<void> deleteAllStudent(List<Student> students) async {
    await _studentDeletionAdapter.deleteList(students);
  }
}
