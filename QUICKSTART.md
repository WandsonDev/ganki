# Ganki - Guia Rápido ⚡

Comece a criar decks Anki em menos de 5 minutos!

## 🚀 Instalação Rápida

```bash
dart pub add ganki
# ou
flutter pub add ganki
```

## 📝 Seu Primeiro Deck (3 passos)

### 1️⃣ Criar o arquivo

```dart
// deck_simples.dart
import 'package:ganki/ganki.dart';

void main() async {
  // Criar uma nota
  final nota = Note(
    model: basicModel,  // modelo pronto
    fields: ['O que é Flutter?', 'Framework para apps multiplataforma'],
  );

  // Criar um deck
  final deck = Deck(
    deckId: 2059400110,
    name: 'Flutter Quiz',
  );
  deck.addNote(nota);

  // Exportar para .apkg
  final package = Package(deck);
  await package.writeToFile('flutter_quiz.apkg');
  
  print('✅ Deck criado: flutter_quiz.apkg');
}
```

### 2️⃣ Executar

```bash
dart run deck_simples.dart
```

### 3️⃣ Importar no Anki

1. Abra o Anki
2. File → Import
3. Selecione `flutter_quiz.apkg`
4. Pronto! 🎉

## 🎯 Modelos Prontos

Use sem configurar nada:

```dart
// Básico (Frente → Verso)
Note(model: basicModel, fields: ['Pergunta', 'Resposta'])

// Frente ⇄ Verso (2 cards)
Note(model: basicAndReversedCardModel, fields: ['PT', 'EN'])

// Cloze (Oclusão)
Note(model: clozeModel, fields: [
  'A capital do {{c1::Brasil}} é {{c2::Brasília}}',
  'Geografia'
])
```

## 💡 Exemplos Comuns

### Vocabulário de Idiomas

```dart
final vocab = Deck(deckId: 123, name: 'Inglês');

vocab.addNote(Note(
  model: basicAndReversedCardModel,
  fields: ['Hello', 'Olá'],
  tags: ['saudações'],
));

vocab.addNote(Note(
  model: basicAndReversedCardModel,
  fields: ['Thank you', 'Obrigado'],
  tags: ['saudações'],
));
```

### Quiz de Programação

```dart
final quiz = Deck(deckId: 456, name: 'Dart Quiz');

quiz.addNote(Note(
  model: basicModel,
  fields: [
    'O que é Future?',
    'Representa um valor que estará disponível no futuro'
  ],
  tags: ['async', 'dart'],
));
```

### Fórmulas Matemáticas

```dart
final math = Deck(deckId: 789, name: 'Matemática');

math.addNote(Note(
  model: clozeModel,
  fields: [
    'Teorema de Pitágoras: {{c1::a²}} + {{c2::b²}} = {{c3::c²}}',
    'Triângulo retângulo'
  ],
));
```

## 🎨 Personalizar Visual (Opcional)

```dart
final meuModelo = Model(
  modelId: 999,
  name: 'Modelo Colorido',
  fields: [
    {'name': 'Pergunta'},
    {'name': 'Resposta'},
  ],
  templates: [{
    'name': 'Card 1',
    'qfmt': '{{Pergunta}}',
    'afmt': '{{FrontSide}}<hr>{{Resposta}}',
  }],
  css: '''
    .card {
      font-size: 24px;
      text-align: center;
      color: white;
      background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
    }
  ''',
);
```

## 📦 Múltiplos Decks em 1 Arquivo

```dart
final deck1 = Deck(deckId: 1, name: 'Geografia');
deck1.addNote(Note(model: basicModel, fields: ['Capital do Brasil?', 'Brasília']));

final deck2 = Deck(deckId: 2, name: 'História');
deck2.addNote(Note(model: basicModel, fields: ['Descobrimento?', '1500']));

// Exportar tudo junto
await Package([deck1, deck2]).writeToFile('tudo.apkg');
```

## 🔧 Dicas Úteis

### Gerar IDs Únicos
```dart
import 'dart:math';

int gerarId() {
  final random = Random();
  return random.nextInt(1 << 30) + (1 << 30);
}

final meuDeck = Deck(deckId: gerarId(), name: 'Meu Deck');
```

### Escapar HTML
```dart
import 'package:ganki/ganki.dart';

final texto = escapeHtml('5 < 10 & x > 3');
// Resultado: '5 &lt; 10 &amp; x &gt; 3'
```

### Importar de Lista
```dart
final palavras = [
  ['Hello', 'Olá'],
  ['Goodbye', 'Tchau'],
  ['Thank you', 'Obrigado'],
];

final deck = Deck(deckId: 123, name: 'Inglês Básico');

for (final par in palavras) {
  deck.addNote(Note(
    model: basicAndReversedCardModel,
    fields: par,
  ));
}

await Package(deck).writeToFile('ingles.apkg');
```

## 🐛 Problemas Comuns

### "Number of fields does not match"
**Solução:** Certifique-se de que o número de fields corresponde ao modelo:
```dart
// ❌ Errado
Note(model: basicModel, fields: ['Só um campo'])

// ✅ Correto
Note(model: basicModel, fields: ['Campo 1', 'Campo 2'])
```

### IDs Duplicados
**Solução:** Use IDs únicos diferentes para cada deck/modelo:
```dart
final deck1 = Deck(deckId: 1001, name: 'Deck 1');
final deck2 = Deck(deckId: 1002, name: 'Deck 2'); // ID diferente!
```

## 📚 Próximos Passos

1. ✅ Você já criou seu primeiro deck!
2. 📖 Leia o [README.md](README.md) completo
3. 🔍 Veja exemplos avançados em `example/`
4. 🎯 Explore os [modelos customizados](README.md#custom-css-e-formatação)
5. 🚀 Crie algo incrível!

## 🆘 Precisa de Ajuda?

- 📖 [Documentação Completa](README.md)
- 💬 [Issues no GitHub](https://github.com/yourusername/ganki/issues)
- 🌟 [Exemplos Avançados](example/advanced_example.dart)

---

**Pronto para criar decks incríveis? Vamos lá! 🚀**

```dart
// Seu código começa aqui! 👇
import 'package:ganki/ganki.dart';

void main() async {
  // Crie algo incrível! ✨
}
```