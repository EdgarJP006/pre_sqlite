// lib/viewmodels/chapter_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:pre_sqlite/utils/db_queries.dart';
import 'package:pre_sqlite/models/bible_model.dart';

class ChapterViewModel extends ChangeNotifier {
  List<BibleChapter> chapterVerseList = [];
  List<BibleBook> books = [];

  ChapterViewModel() {
    getData();
  }

  void getData() async {
    var dbHelper = DBHelper();
    chapterVerseList = await dbHelper.getChapters();
    books = await dbHelper.getBooks();
    notifyListeners();
  }
}
