import 'package:flutter/material.dart';
import 'package:pre_sqlite/views/parses_xml.dart';
import 'package:pre_sqlite/helper/bible_db_helper.dart';
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
    // TODO: implement initState
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
        title: Text(books.length > 0 ? books[0].longname : ''),
      ),
      body: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: chapter_verse_list == null ? 0 : chapter_verse_list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: RichText(
              text: parseText(context,
                  '${chapter_verse_list[index].verse} ${chapter_verse_list[index].text}'),
            ),
          );
        },
      ),
    );
  }
}
