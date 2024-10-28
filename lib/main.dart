import 'package:flutter/material.dart';
import 'package:pre_sqlite/views/chapter_verse_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SQFLite DataBase Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ChapterListPage(),
    );
  }
}
