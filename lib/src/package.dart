import 'dart:io';
import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'deck.dart';
import 'schema.dart';

/// Represents an Anki package (.apkg file)
class Package {
  final List<Deck> decks;
  final List<String> mediaFiles;
  static bool _initialized = false;

  Package(dynamic deckOrDecks, {List<String>? mediaFiles})
      : decks = deckOrDecks is Deck ? [deckOrDecks] : deckOrDecks as List<Deck>,
        mediaFiles = mediaFiles ?? [];

  /// Initialize sqflite_ffi (call once at app start)
  static void initialize() {
    if (!_initialized) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _initialized = true;
    }
  }

  /// Write package to .apkg file
  Future<void> writeToFile(String filePath, {double? timestamp}) async {
    initialize(); // Auto-initialize if not done

    timestamp ??= DateTime.now().millisecondsSinceEpoch / 1000.0;

    // Create temporary database file
    final tempDir = await Directory.systemTemp.createTemp('ganki_');
    final dbPath = path.join(tempDir.path, 'collection.anki2');

    try {
      // Create and populate database
      final db = await databaseFactoryFfi.openDatabase(dbPath);

      try {
        await _writeToDb(db, timestamp);
      } finally {
        await db.close();
      }

      // Create zip archive
      final archive = Archive();

      // Add database file
      final dbFile = File(dbPath);
      final dbBytes = await dbFile.readAsBytes();
      archive.addFile(ArchiveFile('collection.anki2', dbBytes.length, dbBytes));

      // Add media files
      final Map<int, String> mediaJson = {};
      for (var i = 0; i < mediaFiles.length; i++) {
        final mediaPath = mediaFiles[i];
        final mediaFile = File(mediaPath);

        if (await mediaFile.exists()) {
          final mediaBytes = await mediaFile.readAsBytes();
          final mediaBasename = path.basename(mediaPath);

          mediaJson[i] = mediaBasename;
          archive.addFile(
              ArchiveFile(i.toString(), mediaBytes.length, mediaBytes));
        }
      }

      // Add media JSON
      final mediaJsonStr = json.encode(mediaJson);
      final mediaJsonBytes = utf8.encode(mediaJsonStr);
      archive
          .addFile(ArchiveFile('media', mediaJsonBytes.length, mediaJsonBytes));

      // Write archive to file
      final encoder = ZipEncoder();
      final outputFile = File(filePath);
      final outputStream = OutputFileStream(filePath);
      encoder.encode(archive, output: outputStream);
      await outputStream.close();
    } finally {
      // Clean up temporary directory
      await tempDir.delete(recursive: true);
    }
  }

  /// Write decks to database
  Future<void> _writeToDb(Database db, double timestamp) async {
    // Create schema - split into individual statements
    final schemaStatements =
        apkgSchema.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty);

    for (final statement in schemaStatements) {
      await db.execute('$statement;');
    }

    // Insert initial data - split into individual statements
    final colStatements =
        apkgCol.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty);

    for (final statement in colStatements) {
      if (statement.isNotEmpty) {
        await db.execute('$statement;');
      }
    }

    // ID generator
    int currentId = (timestamp * 1000).toInt();
    int idGen() => currentId++;

    // Write each deck
    for (final deck in decks) {
      await deck.writeToDb(
        db: db,
        timestamp: timestamp,
        idGen: idGen,
      );
    }
  }

  @override
  String toString() {
    return 'Package(deckCount: ${decks.length}, mediaCount: ${mediaFiles.length})';
  }
}
