import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'model.dart';
import 'card.dart';
import 'util.dart';

/// Represents an Anki note
class Note {
  final Model model;
  final List<String> fields;
  String? _sortField;
  List<String> tags;
  String? _guid;
  final int due;

  List<Card>? _cachedCards;

  Note({
    required this.model,
    required this.fields,
    String? sortField,
    List<String>? tags,
    String? guid,
    this.due = 0,
  })  : tags = tags ?? [],
        _sortField = sortField,
        _guid = guid;

  /// Get or compute the sort field
  String get sortField {
    return _sortField ?? fields[model.sortFieldIndex];
  }

  set sortField(String? value) {
    _sortField = value;
  }

  /// Get or generate GUID
  String get guid {
    return _guid ?? guidFor(fields);
  }

  set guid(String? value) {
    _guid = value;
  }

  /// Get cards generated from this note
  List<Card> get cards {
    if (_cachedCards != null) return _cachedCards!;

    if (model.modelType == ModelType.cloze) {
      _cachedCards = _generateClozeCards();
    } else {
      _cachedCards = _generateFrontBackCards();
    }

    return _cachedCards!;
  }

  /// Generate cards for cloze note type
  List<Card> _generateClozeCards() {
    final Set<int> cardOrds = {};
    final template = model.templates[0];

    // Find cloze fields in template
    final clozePattern = RegExp(r'{{[^}]*?cloze:(?:[^}]?:)*(.+?)}}');
    final clozeReplacements = clozePattern
        .allMatches(template['qfmt'] as String)
        .map((m) => m.group(1)!)
        .toSet();

    // Find cloze references in field values
    for (final fieldName in clozeReplacements) {
      final fieldIndex = model.fields.indexWhere((f) => f['name'] == fieldName);

      if (fieldIndex >= 0 && fieldIndex < fields.length) {
        final fieldValue = fields[fieldIndex];
        final clozeNumPattern = RegExp(r'{{c(\d+)::.+?}}', dotAll: true);

        for (final match in clozeNumPattern.allMatches(fieldValue)) {
          final num = int.tryParse(match.group(1)!);
          if (num != null && num > 0) {
            cardOrds.add(num - 1);
          }
        }
      }
    }

    if (cardOrds.isEmpty) {
      cardOrds.add(0);
    }

    return cardOrds.map((ord) => Card(ord: ord)).toList();
  }

  /// Generate cards for front/back note type
  List<Card> _generateFrontBackCards() {
    final List<Card> cards = [];

    for (final reqItem in model.req) {
      final cardOrd = reqItem[0] as int;
      final anyOrAll = reqItem[1] as String;
      final requiredFieldOrds = reqItem[2] as List<int>;

      final bool shouldCreate;
      if (anyOrAll == 'any') {
        shouldCreate = requiredFieldOrds
            .any((ord) => ord < fields.length && fields[ord].isNotEmpty);
      } else {
        shouldCreate = requiredFieldOrds
            .every((ord) => ord < fields.length && fields[ord].isNotEmpty);
      }

      if (shouldCreate) {
        cards.add(Card(ord: cardOrd));
      }
    }

    return cards;
  }

  /// Write note to SQLite database
  Future<void> writeToDb({
    required Database db,
    required double timestamp,
    required int deckId,
    required int Function() idGen,
  }) async {
    // Validate field count
    if (fields.length != model.fields.length) {
      throw Exception(
          'Number of fields (${fields.length}) does not match model '
          '(${model.fields.length})');
    }

    // Insert note
    final noteId = idGen();
    await db.rawInsert('''
      INSERT INTO notes VALUES(?,?,?,?,?,?,?,?,?,?,?);
    ''', [
      noteId,
      guid,
      model.modelId,
      timestamp.toInt(),
      -1,
      _formatTags(),
      _formatFields(),
      sortField,
      0,
      0,
      '',
    ]);

    // Insert cards
    for (final card in cards) {
      await card.writeToDb(
        db: db,
        timestamp: timestamp,
        deckId: deckId,
        noteId: noteId,
        idGen: idGen,
        due: due,
      );
    }
  }

  String _formatFields() {
    return fields.join('\x1f');
  }

  String _formatTags() {
    if (tags.isEmpty) return ' ';
    return ' ${tags.join(' ')} ';
  }

  @override
  String toString() {
    return 'Note(model: ${model.name}, fields: $fields, '
        'sortField: $sortField, tags: $tags, guid: $guid)';
  }
}
