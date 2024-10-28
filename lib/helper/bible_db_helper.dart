import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pre_sqlite/models/bible_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "nkjv.SQLite3");
    bool dbExists = await io.File(path).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load(join("assets", "nkjv.SQLite3"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  Future<List<BibleChapter>> getChapters() async {
    var dbChapter = await db;
    List<Map> list = await dbChapter!.rawQuery(
        'SELECT * FROM verses WHERE book_number = 470 AND chapter = 5');
    List<BibleChapter> dbBibleChapter = [];

    for (int i = 0; i < list.length; i++) {
      // Usa cleanText en el campo 'text' antes de añadirlo a la lista
      String cleanVerseText = cleanText(list[i]["text"]);
      dbBibleChapter.add(BibleChapter(list[i]["book_number"],
          list[i]["chapter"], list[i]["verse"], list[i]["text"]));
    }
    return dbBibleChapter;
  }

  Future<List<BibleBook>> getBooks() async {
    var dbBook = await db;
    List<Map> list =
        await dbBook!.rawQuery('SELECT * FROM books WHERE book_number = 10');
    List<BibleBook> dbBibleBook = [];

    for (int i = 0; i < list.length; i++) {
      dbBibleBook.add(BibleBook(
          list[i]["book_number"],
          list[i]["short_name"],
          list[i]["long_name"],
          list[i]["book_color"],
          list[i]["sorting_order"]));
    }
    return dbBibleBook;
  }

  String cleanText(String text) {
    return text
            .replaceAll('<pb/>', '') // Elimina saltos de página
            .replaceAll(RegExp(r'<f>\[.*?\]</f>'), '') // Elimina referencias

        ;
  }
}
