# Estrutura do Projeto Ganki

```
ganki/
│
├── lib/
│   ├── ganki.dart                 # Arquivo principal de exportação
│   │
│   └── src/
│       ├── model.dart             # Classe Model (tipos de nota)
│       ├── note.dart              # Classe Note (conteúdo)
│       ├── card.dart              # Classe Card (cartas individuais)
│       ├── deck.dart              # Classe Deck (coleção)
│       ├── package.dart           # Classe Package (gerador .apkg)
│       ├── schema.dart            # Schema SQL do Anki
│       ├── util.dart              # Funções utilitárias
│       └── builtin_models.dart    # Modelos pré-definidos
│
├── example/
│   ├── main.dart                  # Exemplos básicos
│   └── advanced_example.dart      # Exemplos avançados
│
├── test/
│   └── ganki_test.dart           # Testes unitários
│
├── pubspec.yaml                   # Dependências do projeto
├── analysis_options.yaml          # Configuração do linter
├── README.md                      # Documentação principal
├── CHANGELOG.md                   # Histórico de mudanças
├── LICENSE                        # Licença MIT
└── PROJECT_STRUCTURE.md          # Este arquivo

```

## Descrição dos Arquivos

### lib/ganki.dart
Arquivo principal que exporta todas as classes públicas da biblioteca.

### lib/src/

#### model.dart
- **Classe `Model`**: Define a estrutura dos cards
- **Enum `ModelType`**: FRONT_BACK ou CLOZE
- Calcula campos obrigatórios automaticamente
- Converte para JSON do formato Anki

#### note.dart
- **Classe `Note`**: Representa uma nota (fato a memorizar)
- Gera GUIDs automaticamente
- Cria cards baseados no modelo
- Suporta cloze deletion
- Gerencia tags

#### card.dart
- **Classe `Card`**: Representa um card individual
- Escreve para o banco de dados SQLite
- Suporta suspensão de cards

#### deck.dart
- **Classe `Deck`**: Coleção de notas
- Gerencia múltiplas notas e modelos
- Converte para JSON do Anki
- Escreve no banco de dados

#### package.dart
- **Classe `Package`**: Cria arquivo .apkg
- Gerencia múltiplos decks
- Suporta arquivos de mídia
- Cria arquivo ZIP com banco SQLite

#### schema.dart
- Constantes com schema SQL do Anki
- Estrutura inicial do banco de dados
- Compatível com Anki 2.1+

#### util.dart
- `guidFor()`: Gera GUIDs únicos usando SHA256
- `escapeHtml()`: Escapa caracteres HTML
- Tabela Base91 para encoding

#### builtin_models.dart
- `basicModel`: Modelo básico front/back
- `basicAndReversedCardModel`: Frente/verso reversível
- `basicOptionalReversedCardModel`: Reverso opcional
- `basicTypeInTheAnswerModel`: Com digitação
- `clozeModel`: Modelo de oclusão

## Como Usar

### 1. Adicionar ao projeto

```yaml
# pubspec.yaml
dependencies:
  ganki: ^2.0.0
```

### 2. Importar

```dart
import 'package:ganki/ganki.dart';
```

### 3. Criar deck básico

```dart
final note = Note(
  model: basicModel,
  fields: ['Pergunta', 'Resposta'],
);

final deck = Deck(
  deckId: 123456789,
  name: 'Meu Deck',
);
deck.addNote(note);

final package = Package(deck);
await package.writeToFile('output.apkg');
```

## Dependências

| Pacote | Versão | Uso |
|--------|--------|-----|
| archive | ^3.6.1 | Criação de arquivos ZIP |
| sqlite3 | ^2.4.6 | Banco de dados SQLite |
| mustache_template | ^2.0.0 | Renderização de templates |
| crypto | ^3.0.3 | Hash SHA256 para GUIDs |
| path | ^1.9.0 | Manipulação de caminhos |

## Testes

Execute os testes com:

```bash
dart test
```

## Exemplos

Execute os exemplos com:

```bash
dart run example/main.dart
dart run example/advanced_example.dart
```

## Compilar para Produção

### Como pacote Dart puro:
```bash
dart pub publish --dry-run  # Testar
dart pub publish            # Publicar no pub.dev
```

### Como app Flutter:
```bash
flutter build apk           # Android
flutter build ios           # iOS
flutter build web           # Web
flutter build windows       # Windows
flutter build macos         # macOS
flutter build linux         # Linux
```

## Fluxo de Dados

```
Note + Model
    ↓
  Deck
    ↓
 Package
    ↓
SQLite DB → ZIP → .apkg file
```

## Formato .apkg

Um arquivo .apkg é um ZIP contendo:
- `collection.anki2` - Banco de dados SQLite
- `media` - JSON com mapeamento de arquivos de mídia
- `0`, `1`, `2`, ... - Arquivos de mídia (áudio, imagens)

## Compatibilidade

- ✅ Anki Desktop 2.1+
- ✅ AnkiDroid
- ✅ AnkiMobile (iOS)
- ✅ AnkiWeb

## Roadmap

### v1.1.0 (Planejado)
- [ ] Leitura de arquivos .apkg existentes
- [ ] Importação de CSV aprimorada
- [ ] Mais modelos built-in

### v1.2.0 (Planejado)
- [ ] Suporte a LaTeX melhorado
- [ ] Validação de templates
- [ ] Otimizações de performance

### v2.0.0 (Futuro)
- [ ] Suporte completo para web
- [ ] Interface visual (opcional)
- [ ] Plugin para editores

## Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Arquitetura

```
┌─────────────────────────────────────┐
│          User Code                  │
└─────────────┬───────────────────────┘
              │
              ↓
┌─────────────────────────────────────┐
│       Ganki Public API              │
│  (Model, Note, Card, Deck, Package) │
└─────────────┬───────────────────────┘
              │
        ┌─────┴─────┐
        ↓           ↓
┌──────────────┐ ┌──────────────┐
│   Mustache   │ │   SQLite3    │
│   Templates  │ │   Database   │
└──────────────┘ └──────────────┘
        │           │
        └─────┬─────┘
              ↓
      ┌──────────────┐
      │   Archive    │
      │   (ZIP)      │
      └──────┬───────┘
              ↓
         .apkg file
```

## Licença

MIT License - veja LICENSE para detalhes.

---

**Ganki** - Biblioteca Dart/Flutter para criação de decks Anki! 🚀