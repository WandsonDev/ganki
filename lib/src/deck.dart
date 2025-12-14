import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'model.dart';
import 'note.dart';

/// Represents an Anki deck
class Deck {
  final int deckId;
  final String name;
  final String description;
  final List<Note> notes = [];
  final Map<int, Model> _models = {};

  Deck({
    required this.deckId,
    required this.name,
    this.description = '',
  });

  /// Add a note to this deck
  void addNote(Note note) {
    notes.add(note);
    _models[note.model.modelId] = note.model;
  }

  /// Convert deck to JSON for Anki database
  Map<String, dynamic> toJson() {
    return {
      'collapsed': false,
      'conf': 1,
      'desc': description,
      'dyn': 0,
      'extendNew': 0,
      'extendRev': 50,
      'id': deckId,
      'lrnToday': [163, 2],
      'mod': 1425278051,
      'name': name,
      'newToday': [163, 2],
      'revToday': [163, 0],
      'timeToday': [163, 23598],
      'usn': -1,
    };
  }

  /// Write deck to SQLite database
  Future<void> writeToDb({
    required Database db,
    required double timestamp,
    required int Function() idGen,
  }) async {
    // Validate deck properties
    if (deckId is! int) {
      throw TypeError();
    }
    if (name is! String) {
      throw TypeError();
    }

    // Update decks in col table
    final List<Map<String, dynamic>> decksResult =
        await db.rawQuery('SELECT decks FROM col');
    final String decksJsonStr = decksResult.first['decks'] as String;
    final Map<String, dynamic> decks = json.decode(decksJsonStr);
    decks[deckId.toString()] = toJson();

    await db.rawUpdate(
      'UPDATE col SET decks = ?',
      [json.encode(decks)],
    );

    // Update models in col table
    final List<Map<String, dynamic>> modelsResult =
        await db.rawQuery('SELECT models FROM col');
    final String modelsJsonStr = modelsResult.first['models'] as String;
    final Map<String, dynamic> models = json.decode(modelsJsonStr);

    for (final model in _models.values) {
      models[model.modelId.toString()] = model.toJson(timestamp, deckId);
    }

    await db.rawUpdate(
      'UPDATE col SET models = ?',
      [json.encode(models)],
    );

    // Write all notes
    for (final note in notes) {
      await note.writeToDb(
        db: db,
        timestamp: timestamp,
        deckId: deckId,
        idGen: idGen,
      );
    }
  }

  @override
  String toString() {
    return 'Deck(deckId: $deckId, name: $name, noteCount: ${notes.length})';
  }
}
