// db_queries.dart

import 'package:pre_sqlite/models/bible_model.dart';
import 'package:sqflite/sqflite.dart';
import 'db_initializer.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await DBInitializer.initDb();
    return _db!;
  }

  Future<List<BibleChapter>> getChapters() async {
    final dbChapter = await db;
    final List<Map<String, dynamic>> list = await dbChapter.rawQuery(
        'SELECT * FROM verses WHERE book_number = 470 AND chapter = 5');

    return list.map((item) {
      //String cleanVerseText = cleanText(item["text"]);
      return BibleChapter(
        item["book_number"],
        item["chapter"],
        item["verse"],
        item["text"],
      );
    }).toList();
  }

  Future<List<BibleBook>> getBooks() async {
    final dbBook = await db;
    final List<Map<String, dynamic>> list =
        await dbBook.rawQuery('SELECT * FROM books WHERE book_number = 10');

    return list.map((item) {
      return BibleBook(
        item["book_number"],
        item["short_name"],
        item["long_name"],
        item["book_color"],
        item["sorting_order"],
      );
    }).toList();
  }

  String cleanText(String text) {
    return text
        .replaceAll('<pb/>', '')
        .replaceAll(RegExp(r'<f>\[.*?\]</f>'), '');
  }
}
