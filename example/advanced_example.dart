import 'dart:math';
import 'package:ganki/ganki.dart';

void main() async {
  // Generate unique IDs
  final random = Random();
  int generateId() => random.nextInt(1 << 30) + (1 << 30);

  // Example 1: Programming vocabulary with syntax highlighting
  await programmingVocabulary(generateId);

  // Example 2: Language learning with audio
  await languageLearning(generateId);

  // Example 3: Math formulas with LaTeX
  await mathFormulas(generateId);

  // Example 4: Import from JSON
  await importFromJson(generateId);
}

/// Example 1: Programming vocabulary deck
Future<void> programmingVocabulary(int Function() generateId) async {
  print('Creating programming vocabulary deck...');

  final model = Model(
    modelId: generateId(),
    name: 'Programming Concept',
    fields: [
      {'name': 'Concept'},
      {'name': 'Definition'},
      {'name': 'Code Example'},
      {'name': 'Language'},
    ],
    templates: [
      {
        'name': 'Concept to Definition',
        'qfmt': '''
          <div class="concept">{{Concept}}</div>
          <div class="language">{{Language}}</div>
        ''',
        'afmt': '''
          {{FrontSide}}
          <hr id="answer">
          <div class="definition">{{Definition}}</div>
          <pre><code>{{Code Example}}</code></pre>
        ''',
      },
    ],
    css: '''
      .card {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-size: 18px;
        text-align: left;
        color: #333;
        background-color: #f5f5f5;
        padding: 20px;
      }
      .concept {
        font-size: 28px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 10px;
      }
      .language {
        display: inline-block;
        background: #3498db;
        color: white;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 14px;
        margin-bottom: 15px;
      }
      .definition {
        font-size: 18px;
        line-height: 1.6;
        margin: 15px 0;
        color: #555;
      }
      pre {
        background: #2d2d2d;
        color: #f8f8f2;
        padding: 15px;
        border-radius: 8px;
        overflow-x: auto;
        font-family: 'Courier New', monospace;
        font-size: 14px;
      }
      code {
        font-family: 'Courier New', monospace;
      }
    ''',
  );

  final deck = Deck(
    deckId: generateId(),
    name: 'Programming Concepts',
    description: 'Essential programming concepts and patterns',
  );

  // Add some programming concepts
  final concepts = [
    {
      'concept': 'Closure',
      'definition':
          'A function that captures and remembers the environment in which it was created',
      'code':
          'Function makeCounter() {\n  int count = 0;\n  return () => ++count;\n}\nvar counter = makeCounter();\nprint(counter()); // 1',
      'language': 'Dart',
    },
    {
      'concept': 'Async/Await',
      'definition':
          'Syntactic sugar for working with Futures, making asynchronous code look synchronous',
      'code':
          'Future<String> fetchData() async {\n  await Future.delayed(Duration(seconds: 1));\n  return "Data loaded";\n}',
      'language': 'Dart',
    },
    {
      'concept': 'Stream',
      'definition': 'An asynchronous sequence of data events',
      'code':
          'Stream<int> countStream() async* {\n  for (int i = 1; i <= 5; i++) {\n    await Future.delayed(Duration(seconds: 1));\n    yield i;\n  }\n}',
      'language': 'Dart',
    },
  ];

  for (final concept in concepts) {
    deck.addNote(Note(
      model: model,
      fields: [
        concept['concept']!,
        concept['definition']!,
        concept['code']!,
        concept['language']!,
      ],
      tags: ['programming', 'dart'],
    ));
  }

  final package = Package(deck);
  await package.writeToFile('programming_concepts.apkg');
  print('✓ Created programming_concepts.apkg');
}

/// Example 2: Language learning with emphasis on pronunciation
Future<void> languageLearning(int Function() generateId) async {
  print('Creating language learning deck...');

  final model = Model(
    modelId: generateId(),
    name: 'Language Card Advanced',
    fields: [
      {'name': 'Word'},
      {'name': 'Pronunciation'},
      {'name': 'Translation'},
      {'name': 'Example Sentence'},
      {'name': 'Notes'},
    ],
    templates: [
      {
        'name': 'Recognition',
        'qfmt': '<div class="word">{{Word}}</div>',
        'afmt': '''
          {{FrontSide}}
          <hr id="answer">
          <div class="pronunciation">/{{Pronunciation}}/</div>
          <div class="translation">{{Translation}}</div>
          <div class="example">{{Example Sentence}}</div>
          {{#Notes}}<div class="notes">💡 {{Notes}}</div>{{/Notes}}
        ''',
      },
      {
        'name': 'Production',
        'qfmt': '<div class="translation-q">{{Translation}}</div>',
        'afmt': '''
          {{FrontSide}}
          <hr id="answer">
          <div class="word-a">{{Word}}</div>
          <div class="pronunciation">/{{Pronunciation}}/</div>
          <div class="example">{{Example Sentence}}</div>
        ''',
      },
    ],
    css: '''
      .card {
        font-family: 'Arial', sans-serif;
        font-size: 20px;
        text-align: center;
        color: #2c3e50;
        background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        padding: 30px;
      }
      .word, .word-a {
        font-size: 36px;
        font-weight: bold;
        color: #e74c3c;
        margin: 20px 0;
      }
      .pronunciation {
        font-size: 22px;
        color: #3498db;
        font-style: italic;
        margin: 15px 0;
      }
      .translation, .translation-q {
        font-size: 24px;
        color: #27ae60;
        margin: 15px 0;
      }
      .example {
        font-size: 18px;
        color: #7f8c8d;
        font-style: italic;
        margin: 20px 0;
        padding: 15px;
        background: rgba(255, 255, 255, 0.7);
        border-radius: 8px;
      }
      .notes {
        font-size: 16px;
        color: #95a5a6;
        margin-top: 20px;
        text-align: left;
        padding: 10px;
        background: rgba(255, 255, 255, 0.5);
        border-left: 3px solid #f39c12;
      }
    ''',
  );

  final deck = Deck(
    deckId: generateId(),
    name: 'Japanese Basics',
    description: 'Essential Japanese vocabulary',
  );

  final words = [
    ['ありがとう', 'arigatō', 'Thank you', 'ありがとうございます。', 'Polite form'],
    [
      'こんにちは',
      'konnichiwa',
      'Hello (daytime)',
      'こんにちは！元気ですか？',
      'Common greeting'
    ],
    ['さようなら', 'sayōnara', 'Goodbye', 'さようなら、また明日。', 'Formal farewell'],
  ];

  for (final word in words) {
    deck.addNote(Note(
      model: model,
      fields: word,
      tags: ['japanese', 'basics', 'greetings'],
    ));
  }

  final package = Package(deck);
  await package.writeToFile('japanese_basics.apkg');
  print('✓ Created japanese_basics.apkg');
}

/// Example 3: Math formulas (demonstrating LaTeX support structure)
Future<void> mathFormulas(int Function() generateId) async {
  print('Creating math formulas deck...');

  final model = Model(
    modelId: generateId(),
    name: 'Math Formula',
    fields: [
      {'name': 'Formula Name'},
      {'name': 'Formula'},
      {'name': 'Explanation'},
      {'name': 'Example'},
    ],
    templates: [
      {
        'name': 'Card 1',
        'qfmt': '<div class="formula-name">{{Formula Name}}</div>',
        'afmt': '''
          {{FrontSide}}
          <hr id="answer">
          <div class="formula">{{Formula}}</div>
          <div class="explanation">{{Explanation}}</div>
          <div class="example">{{Example}}</div>
        ''',
      },
    ],
    css: '''
      .card {
        font-family: 'Georgia', serif;
        font-size: 18px;
        text-align: center;
        color: #2c3e50;
        background-color: #ecf0f1;
        padding: 25px;
      }
      .formula-name {
        font-size: 28px;
        font-weight: bold;
        color: #8e44ad;
        margin-bottom: 20px;
      }
      .formula {
        font-size: 24px;
        font-family: 'Times New Roman', serif;
        color: #2c3e50;
        background: white;
        padding: 20px;
        margin: 20px 0;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      .explanation {
        font-size: 18px;
        color: #7f8c8d;
        margin: 15px 0;
        line-height: 1.6;
      }
      .example {
        font-size: 16px;
        color: #16a085;
        background: #e8f8f5;
        padding: 15px;
        border-radius: 8px;
        margin-top: 15px;
      }
    ''',
  );

  final deck = Deck(
    deckId: generateId(),
    name: 'Math Formulas',
    description: 'Important mathematical formulas',
  );

  final formulas = [
    [
      'Pythagorean Theorem',
      'a² + b² = c²',
      'In a right triangle, the square of the hypotenuse equals the sum of squares of the other two sides',
      'If a=3 and b=4, then c=5 (3² + 4² = 25 = 5²)',
    ],
    [
      'Quadratic Formula',
      'x = (-b ± √(b² - 4ac)) / 2a',
      'Solves quadratic equations of the form ax² + bx + c = 0',
      'For x² - 5x + 6 = 0: x = (5 ± √(25-24))/2 = (5±1)/2, so x=3 or x=2',
    ],
  ];

  for (final formula in formulas) {
    deck.addNote(Note(
      model: model,
      fields: formula,
      tags: ['math', 'formulas'],
    ));
  }

  final package = Package(deck);
  await package.writeToFile('math_formulas.apkg');
  print('✓ Created math_formulas.apkg');
}

/// Example 4: Import from JSON file
Future<void> importFromJson(int Function() generateId) async {
  print('Creating deck from JSON data...');

  // Parse would happen here - simplified for example
  final deck = Deck(
    deckId: generateId(),
    name: 'English Vocabulary',
    description: 'Imported from JSON',
  );

  // Simplified - in real code, parse JSON properly
  deck.addNote(Note(
    model: basicModel,
    fields: [
      'Serendipity',
      'The occurrence of events by chance in a happy way'
    ],
    tags: ['imported', 'vocabulary'],
  ));

  deck.addNote(Note(
    model: basicModel,
    fields: ['Ephemeral', 'Lasting for a very short time'],
    tags: ['imported', 'vocabulary'],
  ));

  final package = Package(deck);
  await package.writeToFile('imported_vocabulary.apkg');
  print('✓ Created imported_vocabulary.apkg');
  print('\nAll advanced examples completed! 🎉');
}
