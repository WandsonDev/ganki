import 'package:mustache_template/mustache.dart';

/// Enum for model types
enum ModelType {
  frontBack,
  cloze,
}

/// Represents an Anki note type (model)
class Model {
  final int modelId;
  final String name;
  final List<Map<String, dynamic>> fields;
  final List<Map<String, dynamic>> templates;
  final String css;
  final ModelType modelType;
  final String latexPre;
  final String latexPost;
  final int sortFieldIndex;

  List<List<dynamic>>? _cachedReq;

  static const String defaultLatexPre = '\\documentclass[12pt]{article}\n'
      '\\special{papersize=3in,5in}\n'
      '\\usepackage[utf8]{inputenc}\n'
      '\\usepackage{amssymb,amsmath}\n'
      '\\pagestyle{empty}\n'
      '\\setlength{\\parindent}{0in}\n'
      '\\begin{document}\n';

  static const String defaultLatexPost = '\\end{document}';

  Model({
    required this.modelId,
    required this.name,
    required this.fields,
    required this.templates,
    this.css = '',
    this.modelType = ModelType.frontBack,
    this.latexPre = defaultLatexPre,
    this.latexPost = defaultLatexPost,
    this.sortFieldIndex = 0,
  });

  /// Get required fields for each template
  List<List<dynamic>> get req {
    if (_cachedReq != null) return _cachedReq!;

    const sentinel = 'SeNtInEl';
    final fieldNames = fields.map((f) => f['name'] as String).toList();
    final List<List<dynamic>> req = [];

    for (var templateOrd = 0; templateOrd < templates.length; templateOrd++) {
      final template = templates[templateOrd];
      final List<int> requiredFields = [];

      // Check if each field is required by rendering without it
      for (var fieldOrd = 0; fieldOrd < fieldNames.length; fieldOrd++) {
        final fieldValues = <String, String>{};
        for (final field in fieldNames) {
          fieldValues[field] = sentinel;
        }
        fieldValues[fieldNames[fieldOrd]] = '';

        final rendered = Template(template['qfmt'] as String,
                lenient: true, htmlEscapeValues: false)
            .renderString(fieldValues);

        if (!rendered.contains(sentinel)) {
          requiredFields.add(fieldOrd);
        }
      }

      if (requiredFields.isNotEmpty) {
        req.add([templateOrd, 'all', requiredFields]);
        continue;
      }

      // Check if any field makes the template render
      for (var fieldOrd = 0; fieldOrd < fieldNames.length; fieldOrd++) {
        final fieldValues = <String, String>{};
        for (final field in fieldNames) {
          fieldValues[field] = '';
        }
        fieldValues[fieldNames[fieldOrd]] = sentinel;

        final rendered = Template(template['qfmt'] as String,
                lenient: true, htmlEscapeValues: false)
            .renderString(fieldValues);

        if (rendered.contains(sentinel)) {
          requiredFields.add(fieldOrd);
        }
      }

      if (requiredFields.isEmpty) {
        throw Exception(
            'Could not compute required fields for template: ${template['name']}');
      }

      req.add([templateOrd, 'any', requiredFields]);
    }

    _cachedReq = req;
    return req;
  }

  /// Convert model to JSON for Anki database
  Map<String, dynamic> toJson(double timestamp, int deckId) {
    // Set default values for templates
    for (var i = 0; i < templates.length; i++) {
      templates[i]['ord'] = i;
      templates[i].putIfAbsent('bafmt', () => '');
      templates[i].putIfAbsent('bqfmt', () => '');
      templates[i].putIfAbsent('bfont', () => '');
      templates[i].putIfAbsent('bsize', () => 0);
      templates[i].putIfAbsent('did', () => null);
    }

    // Set default values for fields
    for (var i = 0; i < fields.length; i++) {
      fields[i]['ord'] = i;
      fields[i].putIfAbsent('font', () => 'Liberation Sans');
      fields[i].putIfAbsent('media', () => []);
      fields[i].putIfAbsent('rtl', () => false);
      fields[i].putIfAbsent('size', () => 20);
      fields[i].putIfAbsent('sticky', () => false);
    }

    return {
      'css': css,
      'did': deckId,
      'flds': fields,
      'id': modelId.toString(),
      'latexPost': latexPost,
      'latexPre': latexPre,
      'latexsvg': false,
      'mod': timestamp.toInt(),
      'name': name,
      'req': req,
      'sortf': sortFieldIndex,
      'tags': [],
      'tmpls': templates,
      'type': modelType == ModelType.cloze ? 1 : 0,
      'usn': -1,
      'vers': [],
    };
  }

  @override
  String toString() {
    return 'Model(modelId: $modelId, name: $name, fields: $fields, '
        'templates: $templates, css: $css, modelType: $modelType)';
  }
}
