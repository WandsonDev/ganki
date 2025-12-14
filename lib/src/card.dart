import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Represents an Anki card
class Card {
  final int ord;
  final bool suspend;

  Card({
    required this.ord,
    this.suspend = false,
  });

  /// Write card to SQLite database
  Future<void> writeToDb({
    required Database db,
    required double timestamp,
    required int deckId,
    required int noteId,
    required int Function() idGen,
    int due = 0,
  }) async {
    final queue = suspend ? -1 : 0;

    await db.rawInsert('''
      INSERT INTO cards VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
    ''', [
      idGen(), // id
      noteId, // nid
      deckId, // did
      ord, // ord
      timestamp.toInt(), // mod
      -1, // usn
      0, // type (=0 for non-Cloze)
      queue, // queue
      due, // due
      0, // ivl
      0, // factor
      0, // reps
      0, // lapses
      0, // left
      0, // odue
      0, // odid
      0, // flags
      '', // data
    ]);
  }

  @override
  String toString() {
    return 'Card(ord: $ord, suspend: $suspend)';
  }
}
