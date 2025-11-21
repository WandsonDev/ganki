import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:sqlite3/sqlite3.dart';

import 'constants.dart';
import 'domain.dart';
import 'utils.dart';

class AnkiPackage {
  final Deck deck;
  final List<String> mediaFiles;

  AnkiPackage({required this.deck, this.mediaFiles = const []});

  /// Gera o arquivo .apkg no caminho especificado.
  void writeToFile(String filename) {
    // 1. Criar DB em memória
    final db = sqlite3.openInMemory();

    try {
      db.execute(sqlSchema);
      final ts = GankiUtils.timestamp();

      // 2. Preparar Models e Decks
      final modelsMap = <String, dynamic>{};
      for (var note in deck.notes) {
        modelsMap[note.model.id.toString()] = note.model.toJson(ts, deck.id);
      }

      final decksMap = {
        deck.id.toString(): deck.toJson()
      };

      db.execute(
        'UPDATE col SET models = ?, decks = ? WHERE id = 1',
        [jsonEncode(modelsMap), jsonEncode(decksMap)],
      );

      // 3. Inserir Notas e Cards
      final stmtNote = db.prepare('INSERT INTO notes VALUES(?,?,?,?,?,?,?,?,?,?,?)');
      final stmtCard = db.prepare('INSERT INTO cards VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

      int idGen = GankiUtils.nowMs();

      for (var note in deck.notes) {
        final noteId = idGen++;
        final fieldStr = note.fields.join('\x1f');
        final tagStr = note.tags.isNotEmpty ? ' ${note.tags.join(' ')} ' : '';

        stmtNote.execute([
          noteId,
          note.guid,
          note.model.id,
          ts,
          -1,
          tagStr,
          fieldStr,
          note.fields.isNotEmpty ? note.fields[0] : '',
          0, // csum (not critical)
          0,
          ''
        ]);

        for (var card in note.cards) {
          stmtCard.execute([
            idGen++,
            noteId,
            deck.id,
            card.ord,
            ts,
            -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''
          ]);
        }
      }
      stmtNote.dispose();
      stmtCard.dispose();

      // 4. Compactar (Zip)
      final encoder = ZipFileEncoder();
      encoder.create(filename);

      // Fazer backup do DB da memória para um arquivo temporário
      // O formato Anki requer que o arquivo se chame 'collection.anki2' dentro do zip
      final tmpDir = Directory.systemTemp.createTempSync('ganki_');
      final tmpDbPath = p.join(tmpDir.path, 'collection.anki2');
      
      final fileDb = sqlite3.open(tmpDbPath);
      db.backup(fileDb);
      fileDb.dispose(); // Fecha para liberar o lock

      encoder.addFile(File(tmpDbPath), 'collection.anki2');

      // Adicionar Mídia
      final mediaMap = <String, String>{};
      for (var i = 0; i < mediaFiles.length; i++) {
        var file = File(mediaFiles[i]);
        if (file.existsSync()) {
          var name = p.basename(mediaFiles[i]);
          mediaMap[i.toString()] = name;
          encoder.addFile(file, i.toString());
        } else {
            print('Warning: Media file not found: ${mediaFiles[i]}');
        }
      }

      encoder.addArchiveFile(
        ArchiveFile('media', mediaMap.toString().length, utf8.encode(jsonEncode(mediaMap)))
      );

      encoder.close();

      // Limpeza
      if (tmpDir.existsSync()) {
        tmpDir.deleteSync(recursive: true);
      }

    } finally {
      db.dispose();
    }
  }
}