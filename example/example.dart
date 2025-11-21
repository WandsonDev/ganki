import 'package:ganki/ganki.dart';

void createDeck() async {
  // 1. Criar o Deck
  final deck = Deck(deckId: 20231121, name: "Meu Deck Flutter");

  // 2. Adicionar Notas
  deck.addNote(Note(
    model: basicModel,
    fields: ["O que é Flutter?", "Um framework UI do Google."],
  ));

  deck.addNote(Note(
    model: basicModel,
    fields: ["Qual linguagem usa?", "Dart"],
  ));

  // 3. Se tiver imagens (carregadas de assets ou rede)
  // final imageBytes = await rootBundle.load('assets/logo.png');
  // final media = [
  //    AnkiMedia(name: "logo.png", data: imageBytes.buffer.asUint8List())
  // ];

  // 4. Gerar o Pacote
  final ankiPackage =
      AnkiPackage(deck: deck); // adicione mediaFiles: media se houver

  try {
    final apkgBytes = await ankiPackage.generateBytes();

    // 5. Salvar
    // Opção A: Flutter Universal (usando package file_saver)
    // await FileSaver.instance.saveFile(
    //   name: 'meu_deck',
    //   ext: 'apkg',
    //   bytes: apkgBytes,
    // );

    // Opção B: Apenas Mobile/Desktop (dart:io)
    // final file = File('meu_deck.apkg');
    // await file.writeAsBytes(apkgBytes);

    print("Sucesso! Tamanho: ${apkgBytes.length} bytes");
  } catch (e) {
    print("Erro: $e");
  }
}
