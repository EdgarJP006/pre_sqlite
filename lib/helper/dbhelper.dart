import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pre_sqlite/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  /// Retrieves the database instance. If the database is already initialized,
  /// it returns the existing instance. Otherwise, it initializes the database
  /// and returns the new instance.

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  /// Initializes the database by checking if the database file exists in the
  /// application's documents directory. If the database file does not exist,
  /// it copies the pre-populated database from the assets directory to the
  /// documents directory. Finally, it opens the database and returns the
  /// database instance.

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "employee.db");
    bool dbExists = await io.File(path).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "employee.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  /// Retrieves a list of employees from the database.
  ///
  /// This method fetches all records from the `Employee` table and converts
  /// each record into an `Employee` object. The resulting list of `Employee`
  /// objects is then returned.

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["First_Name"], list[i]["Last_Name"]));
    }
    return employees;
  }
}
