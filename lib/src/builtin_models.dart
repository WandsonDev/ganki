import 'model.dart';

const String _defaultCss = '''
.card {
 font-family: arial;
 font-size: 20px;
 text-align: center;
 color: black;
 background-color: white;
}
''';

const String _clozeCss = '''
.card {
 font-family: arial;
 font-size: 20px;
 text-align: center;
 color: black;
 background-color: white;
}

.cloze {
 font-weight: bold;
 color: blue;
}
.nightMode .cloze {
 color: lightblue;
}
''';

/// Basic front/back model
final Model basicModel = Model(
  modelId: 1559383000,
  name: 'Basic (ganki)',
  fields: [
    {'name': 'Front', 'font': 'Arial'},
    {'name': 'Back', 'font': 'Arial'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Front}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
    },
  ],
  css: _defaultCss,
);

/// Basic model with reversed card
final Model basicAndReversedCardModel = Model(
  modelId: 1485830179,
  name: 'Basic (and reversed card) (ganki)',
  fields: [
    {'name': 'Front', 'font': 'Arial'},
    {'name': 'Back', 'font': 'Arial'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Front}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
    },
    {
      'name': 'Card 2',
      'qfmt': '{{Back}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Front}}',
    },
  ],
  css: _defaultCss,
);

/// Basic model with optional reversed card
final Model basicOptionalReversedCardModel = Model(
  modelId: 1382232460,
  name: 'Basic (optional reversed card) (ganki)',
  fields: [
    {'name': 'Front', 'font': 'Arial'},
    {'name': 'Back', 'font': 'Arial'},
    {'name': 'Add Reverse', 'font': 'Arial'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Front}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
    },
    {
      'name': 'Card 2',
      'qfmt': '{{#Add Reverse}}{{Back}}{{/Add Reverse}}',
      'afmt': '{{FrontSide}}\n\n<hr id=answer>\n\n{{Front}}',
    },
  ],
  css: _defaultCss,
);

/// Basic model with type in the answer
final Model basicTypeInTheAnswerModel = Model(
  modelId: 1305534440,
  name: 'Basic (type in the answer) (ganki)',
  fields: [
    {'name': 'Front', 'font': 'Arial'},
    {'name': 'Back', 'font': 'Arial'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Front}}\n\n{{type:Back}}',
      'afmt': '{{Front}}\n\n<hr id=answer>\n\n{{type:Back}}',
    },
  ],
  css: _defaultCss,
);

/// Cloze model
final Model clozeModel = Model(
  modelId: 1550428389,
  name: 'Cloze (ganki)',
  modelType: ModelType.cloze,
  fields: [
    {'name': 'Text', 'font': 'Arial'},
    {'name': 'Back Extra', 'font': 'Arial'},
  ],
  templates: [
    {
      'name': 'Cloze',
      'qfmt': '{{cloze:Text}}',
      'afmt': '{{cloze:Text}}<br>\n{{Back Extra}}',
    },
  ],
  css: _clozeCss,
);
