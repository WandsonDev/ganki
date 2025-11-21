import 'package:mustache_template/mustache.dart';
import 'utils.dart';

enum ModelType { frontBack, cloze }

class Model {
  final int id;
  final String name;
  final List<Map<String, dynamic>> fields;
  final List<Map<String, dynamic>> templates;
  final String css;
  final ModelType modelType;
  final String latexPre;
  final String latexPost;
  final int sortFieldIndex;

  Model({
    required this.id,
    required this.name,
    required this.fields,
    required this.templates,
    this.css = '',
    this.modelType = ModelType.frontBack,
    this.latexPre = '\\documentclass[12pt]{article}\n',
    this.latexPost = '\\end{document}',
    this.sortFieldIndex = 0,
  });

  Map<String, dynamic> toJson(int timestamp, int deckId) {
    // Clona e prepara campos
    final pFields = List<Map<String, dynamic>>.from(fields);
    for (var i = 0; i < pFields.length; i++) {
      pFields[i]['ord'] = i;
      pFields[i].putIfAbsent('font', () => 'Arial');
      pFields[i].putIfAbsent('size', () => 20);
      pFields[i].putIfAbsent('media', () => []);
      pFields[i].putIfAbsent('rtl', () => false);
      pFields[i].putIfAbsent('sticky', () => false);
    }

    // Clona e prepara templates
    final pTemplates = List<Map<String, dynamic>>.from(templates);
    for (var i = 0; i < pTemplates.length; i++) {
      pTemplates[i]['ord'] = i;
      pTemplates[i].putIfAbsent('bafmt', () => '');
      pTemplates[i].putIfAbsent('bqfmt', () => '');
      pTemplates[i].putIfAbsent('did', () => null);
    }

    return {
      'css': css,
      'did': deckId,
      'flds': pFields,
      'id': id.toString(),
      'latexPost': latexPost,
      'latexPre': latexPre,
      'mod': timestamp,
      'name': name,
      'req': _computeReq(),
      'sortf': sortFieldIndex,
      'tags': [],
      'tmpls': pTemplates,
      'type': modelType.index,
      'usn': -1,
      'vers': []
    };
  }

  List<dynamic> _computeReq() {
    if (modelType == ModelType.cloze) return [];

    var req = [];
    var sentinel = 'SeNtInEl';
    var fieldNames = fields.map((f) => f['name'] as String).toList();

    for (var i = 0; i < templates.length; i++) {
      var tmpl = templates[i];
      var requiredFields = <int>[];

      for (var fIdx = 0; fIdx < fieldNames.length; fIdx++) {
        var testData = {for (var name in fieldNames) name: ''};
        testData[fieldNames[fIdx]] = sentinel;

        // Renderiza para checar se o campo aparece
        var t = Template(tmpl['qfmt'], htmlEscapeValues: false);
        var rendered = t.renderString(testData);

        if (rendered.contains(sentinel)) {
          requiredFields.add(fIdx);
        }
      }

      if (requiredFields.isNotEmpty) {
        req.add([i, 'any', requiredFields]);
      } else {
        req.add([i, 'all', []]);
      }
    }
    return req;
  }
}

class Card {
  final int ord;
  Card(this.ord);
}

class Note {
  final Model model;
  final List<String> fields;
  final List<String> tags;
  String? _guid;

  Note({
    required this.model,
    required this.fields,
    this.tags = const [],
    String? guid,
  }) {
    _guid = guid;
    if (fields.length != model.fields.length) {
      throw ArgumentError(
          'Field count mismatch. Model "${model.name}" expects ${model.fields.length}, but got ${fields.length}.');
    }
  }

  String get guid => _guid ??= GankiUtils.guidFor(fields);

  List<Card> get cards {
    if (model.modelType == ModelType.frontBack) {
      return List.generate(model.templates.length, (i) => Card(i));
    } else {
      // Lógica Cloze
      var cardOrds = <int>{};
      var pattern = RegExp(r'\{\{c(\d+)::.+?\}\}');
      for (var field in fields) {
        pattern.allMatches(field).forEach((m) {
          var n = int.tryParse(m.group(1)!) ?? 0;
          if (n > 0) cardOrds.add(n - 1);
        });
      }
      if (cardOrds.isEmpty) cardOrds.add(0);
      return cardOrds.map((ord) => Card(ord)).toList();
    }
  }
}

class Deck {
  final int id;
  final String name;
  final String description;
  final List<Note> notes = [];

  Deck({required this.id, required this.name, this.description = ''});

  void addNote(Note note) => notes.add(note);

  Map<String, dynamic> toJson() {
    return {
      'collapsed': false,
      'conf': 1,
      'desc': description,
      'dyn': 0,
      'extendNew': 0,
      'extendRev': 50,
      'id': id,
      'lrnToday': [0, 0],
      'mod': GankiUtils.timestamp(),
      'name': name,
      'newToday': [0, 0],
      'revToday': [0, 0],
      'timeToday': [0, 0],
      'usn': -1
    };
  }
}

// --- Modelos Pré-fabricados ---

final basicModel = Model(
  id: 1698254987,
  name: 'Basic (Dart)',
  fields: [
    {'name': 'Front'},
    {'name': 'Back'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Front}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
    }
  ],
  css: '.card { font-family: arial; font-size: 20px; text-align: center; color: black; background-color: white; }',
);