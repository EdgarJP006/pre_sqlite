import 'package:flutter/material.dart';
import 'package:pre_sqlite/views/parses_xml.dart';
import 'package:pre_sqlite/helper/db_queries.dart';
import 'package:pre_sqlite/models/bible_model.dart';

List<BibleChapter> chapter_verse_list = [];
List<BibleBook> books = [];

class ChapterListPage extends StatefulWidget {
  @override
  _ChapterListPageState createState() => new _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var dbHelper = DBHelper();
    List<BibleChapter> _chapter_verse_list = await dbHelper.getChapters();
    List<BibleBook> _books = await dbHelper.getBooks();
    setState(() {
      chapter_verse_list = _chapter_verse_list;
      books = _books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(books.isNotEmpty ? books[0].longname : ''),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10), // Espacio alrededor del ListView
        itemCount: chapter_verse_list.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
                bottom: 0,
                top: 0,
                left: 5,
                right: 8), // Espacio entre ListTiles
            padding: const EdgeInsets.only(
                bottom: 0,
                top: 0,
                left: 10,
                right: 10), // Espaciado interno del ListTile
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(8),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.shade300,
            //       offset: Offset(0, 1),
            //       blurRadius: 6,
            //     ),
            //   ],
            // ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: RichText(
                text: parseText(
                  context,
                  '${chapter_verse_list[index].verse} ${chapter_verse_list[index].text}',
                ),
                textAlign: TextAlign.justify, // Justificado
              ),
            ),
          );
        },
      ),
    );
  }
}
