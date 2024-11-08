// lib/views/chapter_list_page.dart

import 'package:flutter/material.dart';
import 'package:pre_sqlite/views/parses_xml.dart';
import 'package:provider/provider.dart';
import 'package:pre_sqlite/providers/chapter_viewmodel.dart';

class ChapterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChapterViewModel>(
          builder: (context, viewModel, _) => Text(
            viewModel.books.isNotEmpty ? viewModel.books[0].longname : '',
          ),
        ),
      ),
      body: Consumer<ChapterViewModel>(builder: (context, viewModel, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(10), // Espacio alrededor del ListView
          itemCount: viewModel.chapterVerseList.length,
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
                    '${viewModel.chapterVerseList[index].verse} ${viewModel.chapterVerseList[index].text}',
                  ),
                  textAlign: TextAlign.justify, // Justificado
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
