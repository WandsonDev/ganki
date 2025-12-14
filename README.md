# Ganki


## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  ganki: ^2.0.0
```

Ou execute:

```bash
dart pub add ganki
# ou
flutter pub add ganki
```

### 🐧 Linux: Instalação do SQLite

Se você estiver no Linux, pode precisar instalar o SQLite3:

```bash
# Ubuntu/Debian/PopOS
sudo apt-get install libsqlite3-dev

# Fedora/RedHat
sudo dnf install sqlite-devel

# Arch Linux
sudo pacman -S sqlite
```

**Windows e macOS:** Nenhuma instalação adicional necessária! ✅

📖 Para mais detalhes, veja [INSTALL.md](INSTALL.md)

## 🚀 Uso Básico

### Criando um Deck Simples

```dart
import 'package:ganki/ganki.dart';

void main() async {
  // Criar nota com modelo básico
  final note = Note(
    model: basicModel,
    fields: ['Capital do Brasil', 'Brasília'],
    tags: ['geografia', 'capitais'],
  );

  // Criar deck e adicionar nota
  final deck = Deck(
    deckId: 2059400110,
    name: 'Capitais do Mundo',
    description: 'Aprenda capitais',
  );
  deck.addNote(note);

  // Criar pacote e salvar
  final package = Package(deck);
  await package.writeToFile('capitais.apkg');
}
```

## 📚 Conceitos

### Model (Modelo)

Define a estrutura dos seus cards (campos e templates).

```dart
final customModel = Model(
  modelId: 1607392319,
  name: 'Vocabulário',
  fields: [
    {'name': 'Português'},
    {'name': 'Inglês'},
    {'name': 'Exemplo'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '{{Português}}',
      'afmt': '{{FrontSide}}<hr id="answer">{{Inglês}}<br><i>{{Exemplo}}</i>',
    },
  ],
  css: '.card { font-size: 20px; text-align: center; }',
);
```

**Importante:** 
- `modelId` deve ser único. Gere com: `Random().nextInt(1 << 30) + (1 << 30)`
- `qfmt` = formato da pergunta (question format)
- `afmt` = formato da resposta (answer format)

### Note (Nota)

Representa um fato a memorizar.

```dart
final note = Note(
  model: customModel,
  fields: ['Olá', 'Hello', 'Olá, tudo bem?'],
  tags: ['saudações', 'básico'],
  guid: 'custom-guid-123',  // opcional
);
```

**GUID:** Identificador único. Se não fornecido, é gerado automaticamente a partir dos campos. Notas com mesmo GUID são consideradas a mesma nota (útil para atualizações).

### Deck

Coleção de notas.

```dart
final deck = Deck(
  deckId: 2059400110,  // deve ser único
  name: 'Meu Deck',
  description: 'Descrição opcional',
);

deck.addNote(note1);
deck.addNote(note2);
```

### Package

Arquivo .apkg final que pode ser importado no Anki.

```dart
// Um deck
final package = Package(deck);

// Múltiplos decks
final package = Package([deck1, deck2, deck3]);

// Com arquivos de mídia
final package = Package(deck, mediaFiles: [
  'audio/hello.mp3',
  'images/flag.jpg',
]);

await package.writeToFile('output.apkg');
```

## 🎯 Modelos Prontos

A biblioteca inclui modelos pré-definidos:

### Basic Model
```dart
final note = Note(
  model: basicModel,
  fields: ['Frente', 'Verso'],
);
```

### Basic and Reversed Card
```dart
final note = Note(
  model: basicAndReversedCardModel,
  fields: ['Português', 'English'],
);
// Gera 2 cards: PT→EN e EN→PT
```

### Basic Optional Reversed Card
```dart
final note = Note(
  model: basicOptionalReversedCardModel,
  fields: ['Frente', 'Verso', 'sim'],  // 'sim' ativa o reverso
);
```

### Cloze (Oclusão)
```dart
final note = Note(
  model: clozeModel,
  fields: [
    'A capital do {{c1::Brasil}} é {{c2::Brasília}}',
    'Extra info',
  ],
);
// Gera 2 cards: um para cada {{c1::}} e {{c2::}}
```

## 📖 Exemplos Avançados

### Custom CSS e Formatação

```dart
final model = Model(
  modelId: 1234567890,
  name: 'Modelo Bonito',
  fields: [
    {'name': 'Pergunta'},
    {'name': 'Resposta'},
  ],
  templates: [
    {
      'name': 'Card 1',
      'qfmt': '<div class="question">{{Pergunta}}</div>',
      'afmt': '''
        {{FrontSide}}
        <hr id="answer">
        <div class="answer">{{Resposta}}</div>
      ''',
    },
  ],
  css: '''
    .card {
      font-family: Arial;
      font-size: 24px;
      text-align: center;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px;
    }
    .question {
      font-size: 28px;
      font-weight: bold;
    }
    .answer {
      font-size: 24px;
      margin-top: 20px;
    }
  ''',
);
```

### Importando de CSV

```dart
import 'dart:io';
import 'package:ganki/ganki.dart';

Future<void> importFromCsv(String csvPath) async {
  final file = File(csvPath);
  final lines = await file.readAsLines();
  
  final deck = Deck(
    deckId: 2059400110,
    name: 'Imported from CSV',
  );

  for (final line in lines.skip(1)) {  // pula header
    final parts = line.split(',');
    if (parts.length >= 2) {
      deck.addNote(Note(
        model: basicModel,
        fields: [parts[0].trim(), parts[1].trim()],
      ));
    }
  }

  final package = Package(deck);
  await package.writeToFile('imported.apkg');
}
```

### Múltiplos Templates

```dart
final model = Model(
  modelId: 1234567891,
  name: 'Completo',
  fields: [
    {'name': 'Word'},
    {'name': 'Translation'},
    {'name': 'Example'},
    {'name': 'Audio'},
  ],
  templates: [
    {
      'name': 'Recognition',
      'qfmt': '{{Word}}<br>[sound:{{Audio}}]',
      'afmt': '{{FrontSide}}<hr>{{Translation}}<br><i>{{Example}}</i>',
    },
    {
      'name': 'Production',
      'qfmt': '{{Translation}}',
      'afmt': '{{FrontSide}}<hr>{{Word}}<br>[sound:{{Audio}}]<br><i>{{Example}}</i>',
    },
  ],
);
```

### Usando Mídia (Áudio/Imagens)

```dart
final note = Note(
  model: basicModel,
  fields: [
    'Como se diz "hello"?',
    'Olá [sound:hello.mp3]<br><img src="hello.jpg">',
  ],
);

final package = Package(deck, mediaFiles: [
  'media/hello.mp3',
  'media/hello.jpg',
]);

await package.writeToFile('with_media.apkg');
```

## 🔧 Dicas

### Gerando IDs Únicos

```dart
import 'dart:math';

int generateUniqueId() {
  final random = Random();
  return random.nextInt(1 << 30) + (1 << 30);
}

final deckId = generateUniqueId();
final modelId = generateUniqueId();
```

### Escapando HTML

Se seus campos contêm caracteres especiais (`<`, `>`, `&`), use:

```dart
import 'package:ganki/ganki.dart';

final safeText = escapeHtml('5 < 10 & 20 > 15');
// '5 &lt; 10 &amp; 20 &gt; 15'
```

### Timestamp Customizado

Para builds determinísticos:

```dart
final timestamp = DateTime(2024, 1, 1).millisecondsSinceEpoch / 1000.0;
await package.writeToFile('output.apkg', timestamp: timestamp);
```

## 🎨 Templates Mustache

Os templates usam a sintaxe Mustache:

- `{{Field}}` - Insere o valor do campo
- `{{#Field}}...{{/Field}}` - Renderiza se Field não estiver vazio
- `{{^Field}}...{{/Field}}` - Renderiza se Field estiver vazio
- `{{!comment}}` - Comentário (não renderizado)

## ⚠️ Notas Importantes

1. **IDs devem ser únicos** - Use números aleatórios grandes para evitar conflitos
2. **Campos são HTML** - Escape caracteres especiais se necessário
3. **Cloze precisa de 2 campos** - Sempre forneça 2 campos ao clozeModel
4. **Arquivos de mídia** - Devem existir no caminho especificado
5. **Sort Field** - Por padrão é o primeiro campo, usado para ordenação no Anki

## 🐛 Solução de Problemas

### "Number of fields does not match"
Certifique-se de que o número de campos na Note corresponde ao número de campos no Model.

### "Could not compute required fields"
Verifique se o template `qfmt` está correto e usa os nomes de campos corretos.

### Arquivo .apkg não importa
- Verifique se os IDs são únicos
- Teste com um deck simples primeiro
- Certifique-se de que não há erros no template

## 📝 Licença

MIT License - veja LICENSE para detalhes.

## 🤝 Contribuindo

Contribuições são bem-vindas! Abra issues ou pull requests no GitHub.

## 📚 Recursos

- [Documentação do Anki](https://docs.ankiweb.net/)
- [Genanki (Python)](https://github.com/kerrickstaley/genanki)
- [Mustache Templates](http://mustache.github.io/)

## 🌟 Exemplos

Veja a pasta `example/` para mais exemplos de uso!

---

**Ganki** - Crie decks Anki programaticamente em Dart/Flutter! 🚀