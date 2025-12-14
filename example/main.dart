import 'package:ganki/ganki.dart';

void main() async {
  // Example 1: Basic front/back cards
  await basicExample();

  // Example 2: Custom model
  await customModelExample();

  // Example 3: Cloze cards
  await clozeExample();

  // Example 4: Multiple decks in one package
  await multiDeckExample();
}

/// Example 1: Create a basic deck with front/back cards
Future<void> basicExample() async {
  print('Creating basic deck...');

  // Create notes using the built-in basic model
  final note1 = Note(
    model: basicModel,
    fields: ['Capital of Brazil', 'Brasília'],
    tags: ['geography', 'capitals'],
  );

  final note2 = Note(
    model: basicModel,
    fields: ['Capital of Japan', 'Tokyo'],
    tags: ['geography', 'capitals'],
  );

  // Create a deck and add notes
  final deck = Deck(
    deckId: 2059400110,
    name: 'World Capitals',
    description: 'Learn world capitals',
  );
  deck.addNote(note1);
  deck.addNote(note2);

  // Create package and write to file
  final package = Package(deck);
  await package.writeToFile('world_capitals.apkg');

  print('✓ Created world_capitals.apkg');
}

/// Example 2: Create a deck with a custom model
Future<void> customModelExample() async {
  print('Creating deck with custom model...');

  // Create a custom model
  final customModel = Model(
    modelId: 1607392319,
    name: 'Language Card',
    fields: [
      {'name': 'Portuguese'},
      {'name': 'English'},
      {'name': 'Example'},
    ],
    templates: [
      {
        'name': 'PT -> EN',
        'qfmt': '<div class="portuguese">{{Portuguese}}</div>',
        'afmt': '{{FrontSide}}<hr id="answer">'
            '<div class="english">{{English}}</div>'
            '<div class="example">{{Example}}</div>',
      },
    ],
    css: '''
      .card {
        font-family: arial;
        font-size: 24px;
        text-align: center;
        color: black;
        background-color: white;
      }
      .portuguese {
        font-size: 28px;
        font-weight: bold;
        color: #0066cc;
      }
      .english {
        font-size: 24px;
        color: #006600;
      }
      .example {
        font-size: 18px;
        color: #666;
        font-style: italic;
        margin-top: 20px;
      }
    ''',
  );

  // Create notes
  final note1 = Note(
    model: customModel,
    fields: [
      'Olá',
      'Hello',
      'Olá, como vai?',
    ],
  );

  final note2 = Note(
    model: customModel,
    fields: [
      'Obrigado',
      'Thank you',
      'Muito obrigado pela ajuda!',
    ],
  );

  // Create deck
  final deck = Deck(
    deckId: 2059400111,
    name: 'Portuguese Vocabulary',
  );
  deck.addNote(note1);
  deck.addNote(note2);

  // Create package
  final package = Package(deck);
  await package.writeToFile('portuguese_vocab.apkg');

  print('✓ Created portuguese_vocab.apkg');
}

/// Example 3: Create a deck with cloze deletion cards
Future<void> clozeExample() async {
  print('Creating cloze deck...');

  final note1 = Note(
    model: clozeModel,
    fields: [
      'The capital of {{c1::Brazil}} is {{c2::Brasília}}',
      'South America',
    ],
  );

  final note2 = Note(
    model: clozeModel,
    fields: [
      'Flutter is developed by {{c1::Google}}',
      'Mobile framework',
    ],
  );

  final deck = Deck(
    deckId: 2059400112,
    name: 'Cloze Examples',
  );
  deck.addNote(note1);
  deck.addNote(note2);

  final package = Package(deck);
  await package.writeToFile('cloze_examples.apkg');

  print('✓ Created cloze_examples.apkg');
}

/// Example 4: Multiple decks in one package
Future<void> multiDeckExample() async {
  print('Creating package with multiple decks...');

  // Deck 1: Geography
  final geoDeck = Deck(
    deckId: 2059400113,
    name: 'Geography',
  );
  geoDeck.addNote(Note(
    model: basicModel,
    fields: ['Largest ocean', 'Pacific Ocean'],
  ));

  // Deck 2: Science
  final sciDeck = Deck(
    deckId: 2059400114,
    name: 'Science',
  );
  sciDeck.addNote(Note(
    model: basicModel,
    fields: ['Speed of light', '299,792,458 m/s'],
  ));

  // Create package with multiple decks
  final package = Package([geoDeck, sciDeck]);
  await package.writeToFile('multi_deck.apkg');

  print('✓ Created multi_deck.apkg');
}
