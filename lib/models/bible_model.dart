class BibleChapter {
  final int booknumber;
  final int chapter;
  final int verse;
  final String text;

  BibleChapter(this.booknumber, this.chapter, this.verse, this.text);
}

class BibleBook {
  final int booknumber;
  final String shortname;
  final String longname;
  final String bookcolor;
  final int sortingorder;

  BibleBook(this.booknumber, this.shortname, this.longname, this.bookcolor,
      this.sortingorder);
}
