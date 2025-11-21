# Ganki 🎴

A specialized Dart library for generating Anki decks (`.apkg`) programmatically.

Designed to be cross-platform (Mobile/Desktop) and easy to use with Flutter or standard Dart projects.

## Features

* Create Decks, Notes, and Cards.
* Supports custom Models (Card Types).
* Includes default "Basic" model.
* Supports media embedding (images, audio).
* **Flutter Ready**: Works on Android, iOS, Windows, macOS, Linux.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ganki: ^1.0.0
````

### Flutter Specific Setup

If you are using this in a Flutter app, you must also include the native SQLite libraries:

```yaml
dependencies:
  ganki: ^1.0.0
  sqlite3_flutter_libs: ^0.5.0 # Required for Mobile/Mac/Windows/Linux
```

## Usage

```dart
import 'package:ganki/ganki.dart';

void main() {
  // 1. Create a Deck
  final deck = Deck(id: 20230101, name: "My Dart Deck");

  // 2. Add a Note (using the pre-built Basic Model)
  deck.addNote(Note(
    model: basicModel,
    fields: ["What is Dart?", "A client-optimized language for fast apps."],
    tags: ["programming", "dart"]
  ));

  // 3. Generate Package
  final ankiPackage = AnkiPackage(deck: deck);
  ankiPackage.writeToFile("dart_deck.apkg");
  
  print("Deck generated successfully!");
}
```

### Compatibility

* **Android/iOS/Desktop**: Fully supported via `sqlite3` + `sqlite3_flutter_libs`.
* **Web**: Not currently supported due to file system and synchronous SQLite limitations.

## License

MIT

---

## Example: `example/example.dart`

```dart
import 'dart:io';
import 'package:ganki/ganki.dart';

void main() {
  print('Generating Anki Deck...');

  // 1. Criar Deck
  final myDeck = Deck(
    id: 123456789, // Use um ID único
    name: "Vocabulary::English", // Suporta sub-decks com ::
  );

  // 2. Adicionar Notas
  myDeck.addNote(Note(
    model: basicModel,
    fields: ["Hello", "Olá"],
    tags: ["greeting"]
  ));

  myDeck.addNote(Note(
    model: basicModel,
    fields: ["World", "Mundo"],
  ));

  // 3. Salvar
  final outputName = 'example_deck.apkg';
  final package = AnkiPackage(deck: myDeck);
  
  try {
    package.writeToFile(outputName);
    print('Success! Created $outputName (${File(outputName).lengthSync()} bytes)');
  } catch (e) {
    print('Error: $e');
  }
}
```
