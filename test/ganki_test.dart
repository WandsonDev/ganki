import 'package:test/test.dart';
import 'package:ganki/ganki.dart';

void main() {
  group('Util Tests', () {
    test('guidFor generates consistent GUIDs', () {
      final guid1 = guidFor(['test', '123']);
      final guid2 = guidFor(['test', '123']);
      final guid3 = guidFor(['different', '456']);

      expect(guid1, equals(guid2));
      expect(guid1, isNot(equals(guid3)));
    });

    test('escapeHtml escapes special characters', () {
      expect(escapeHtml('<div>'), equals('&lt;div&gt;'));
      expect(escapeHtml('a & b'), equals('a &amp; b'));
      expect(escapeHtml('"test"'), equals('&quot;test&quot;'));
    });
  });

  group('Model Tests', () {
    test('Model creates with required fields', () {
      final model = Model(
        modelId: 123,
        name: 'Test Model',
        fields: [
          {'name': 'Front'},
          {'name': 'Back'},
        ],
        templates: [
          {
            'name': 'Card 1',
            'qfmt': '{{Front}}',
            'afmt': '{{Back}}',
          },
        ],
      );

      expect(model.modelId, equals(123));
      expect(model.name, equals('Test Model'));
      expect(model.fields.length, equals(2));
      expect(model.templates.length, equals(1));
    });

    test('Model computes req correctly', () {
      final model = Model(
        modelId: 124,
        name: 'Test',
        fields: [
          {'name': 'Front'},
          {'name': 'Back'},
        ],
        templates: [
          {
            'name': 'Card',
            'qfmt': '{{Front}}',
            'afmt': '{{Back}}',
          },
        ],
      );

      final req = model.req;
      expect(req.length, equals(1));
      expect(req[0][0], equals(0)); // template index
      expect(req[0][1], equals('all')); // all fields required
    });
  });

  group('Note Tests', () {
    final testModel = Model(
      modelId: 125,
      name: 'Test',
      fields: [
        {'name': 'Q'},
        {'name': 'A'},
      ],
      templates: [
        {
          'name': 'Card',
          'qfmt': '{{Q}}',
          'afmt': '{{A}}',
        },
      ],
    );

    test('Note creates with fields', () {
      final note = Note(
        model: testModel,
        fields: ['Question', 'Answer'],
        tags: ['test'],
      );

      expect(note.fields.length, equals(2));
      expect(note.tags, equals(['test']));
      expect(note.sortField, equals('Question'));
    });

    test('Note generates GUID', () {
      final note1 = Note(
        model: testModel,
        fields: ['Q1', 'A1'],
      );

      final note2 = Note(
        model: testModel,
        fields: ['Q1', 'A1'],
      );

      expect(note1.guid, equals(note2.guid));
    });

    test('Note generates cards', () {
      final note = Note(
        model: testModel,
        fields: ['Q', 'A'],
      );

      final cards = note.cards;
      expect(cards.length, greaterThan(0));
      expect(cards[0].ord, equals(0));
    });
  });

  group('Cloze Tests', () {
    test('Cloze note generates correct number of cards', () {
      final note = Note(
        model: clozeModel,
        fields: [
          'The {{c1::first}} and {{c2::second}} items',
          'Extra',
        ],
      );

      final cards = note.cards;
      expect(cards.length, equals(2));
    });

    test('Cloze with single deletion', () {
      final note = Note(
        model: clozeModel,
        fields: ['Only {{c1::one}} deletion', ''],
      );

      final cards = note.cards;
      expect(cards.length, equals(1));
    });
  });

  group('Deck Tests', () {
    final testModel = basicModel;

    test('Deck creates and adds notes', () {
      final deck = Deck(
        deckId: 999,
        name: 'Test Deck',
        description: 'Test',
      );

      final note = Note(
        model: testModel,
        fields: ['Q', 'A'],
      );

      deck.addNote(note);

      expect(deck.notes.length, equals(1));
      expect(deck.deckId, equals(999));
      expect(deck.name, equals('Test Deck'));
    });
  });

  group('Built-in Models Tests', () {
    test('All built-in models exist', () {
      expect(basicModel, isNotNull);
      expect(basicAndReversedCardModel, isNotNull);
      expect(basicOptionalReversedCardModel, isNotNull);
      expect(basicTypeInTheAnswerModel, isNotNull);
      expect(clozeModel, isNotNull);
    });

    test('Basic model has correct structure', () {
      expect(basicModel.fields.length, equals(2));
      expect(basicModel.templates.length, equals(1));
      expect(basicModel.modelType, equals(ModelType.frontBack));
    });

    test('Cloze model is correct type', () {
      expect(clozeModel.modelType, equals(ModelType.cloze));
      expect(clozeModel.fields.length, equals(2));
    });
  });
}
