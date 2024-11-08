// lib/main.dart

import 'package:flutter/material.dart';
import 'package:pre_sqlite/providers/chapter_viewmodel.dart';
import 'package:pre_sqlite/views/chapter_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChapterViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChapterListPage(),
    );
  }
}
