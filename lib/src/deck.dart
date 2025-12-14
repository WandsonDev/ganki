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
    // Value validation (not type validation)
    if (deckId <= 0) {
      throw ArgumentError.value(
        deckId,
        'deckId',
        'Must be a positive integer',
      );
    }

    if (name.trim().isEmpty) {
      throw ArgumentError.value(
        name,
        'name',
        'Must not be empty',
      );
    }

    // Update decks in col table
    final decksResult = await db.rawQuery('SELECT decks FROM col');
    final decksJsonStr = decksResult.first['decks'] as String;
    final Map<String, dynamic> decks =
        json.decode(decksJsonStr) as Map<String, dynamic>;

    decks[deckId.toString()] = toJson();

    await db.rawUpdate(
      'UPDATE col SET decks = ?',
      [json.encode(decks)],
    );

    // Update models in col table
    final modelsResult = await db.rawQuery('SELECT models FROM col');
    final modelsJsonStr = modelsResult.first['models'] as String;
    final Map<String, dynamic> models =
        json.decode(modelsJsonStr) as Map<String, dynamic>;

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
