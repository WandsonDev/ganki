# Guia de Instalação - Ganki

## 📦 Instalação Básica

### 1. Adicionar ao projeto

```bash
dart pub add ganki
# ou
flutter pub add ganki
```

### 2. Atualizar dependências

```bash
dart pub get
# ou  
flutter pub get
```

## 🔧 Requisitos do Sistema

A biblioteca Ganki usa `sqflite_common_ffi` que **não precisa de instalação adicional** na maioria dos casos! 🎉

### ✅ Funciona Automaticamente em:

- ✅ **Windows** - Sem configuração adicional
- ✅ **macOS** - Sem configuração adicional  
- ✅ **Linux (Ubuntu/Debian)** - Funciona out-of-the-box na maioria dos casos
- ✅ **Android** (via Flutter) - Sem configuração adicional
- ✅ **iOS** (via Flutter) - Sem configuração adicional

### 🐧 Linux: Se der Erro

Se você estiver no **Linux** e aparecer erro sobre `libsqlite3.so`, instale o SQLite3:

#### Ubuntu/Debian/PopOS:
```bash
sudo apt-get update
sudo apt-get install libsqlite3-dev
```

#### Fedora/RedHat/CentOS:
```bash
sudo dnf install sqlite-devel
# ou
sudo yum install sqlite-devel
```

#### Arch Linux/Manjaro:
```bash
sudo pacman -S sqlite
```

## 🚀 Teste Rápido

Crie um arquivo `test_ganki.dart`:

```dart
import 'package:ganki/ganki.dart';

void main() async {
  print('Testando Ganki...');
  
  final note = Note(
    model: basicModel,
    fields: ['Teste', 'Funcionou!'],
  );

  final deck = Deck(
    deckId: 999999,
    name: 'Teste Ganki',
  );
  deck.addNote(note);

  final package = Package(deck);
  await package.writeToFile('teste.apkg');

  print('✅ Sucesso! Arquivo criado: teste.apkg');
}
```

Execute:
```bash
dart run test_ganki.dart
```

Se aparecer `✅ Sucesso!`, está tudo funcionando! 🎉

## ❌ Problemas Comuns

### Erro: "Failed to load dynamic library"

**Windows:**
- Geralmente não acontece. Se acontecer, reinstale o Visual C++ Redistributable

**macOS:**
- Geralmente não acontece. O SQLite já vem instalado no macOS

**Linux:**
- Instale o SQLite3 conforme instruções acima

### Erro: "MissingPluginException" (Flutter)

Se estiver usando Flutter e aparecer este erro:

```bash
flutter clean
flutter pub get
flutter run
```

### Erro: "Bad state: No element"

Isso pode acontecer se o banco de dados não foi inicializado. Certifique-se de chamar:

```dart
Package.initialize(); // Opcional - é chamado automaticamente
```

## 🔍 Verificar Instalação do SQLite

### Linux:
```bash
sqlite3 --version
# Deve mostrar algo como: 3.31.1 2020-01-27 19:55:54
```

### macOS:
```bash
sqlite3 -version
# SQLite já vem instalado
```

### Windows:
```bash
# Não precisa instalar manualmente, a biblioteca inclui o necessário
```

## 📱 Flutter Mobile

Para projetos Flutter mobile (Android/iOS), **nenhuma configuração adicional é necessária**!

### Android
```bash
flutter build apk
# ou
flutter run
```

### iOS
```bash
flutter build ios
# ou
flutter run
```

## 🖥️ Flutter Desktop

### Linux Desktop
```bash
# Instale as dependências do sistema:
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libsqlite3-dev

flutter build linux
```

### Windows Desktop
```bash
# Sem instalação adicional necessária
flutter build windows
```

### macOS Desktop
```bash
# Sem instalação adicional necessária
flutter build macos
```

## 🌐 Flutter Web

⚠️ **Nota:** A versão atual do Ganki não suporta Flutter Web porque o SQLite não funciona no navegador. Use para:
- Desktop (Windows, Linux, macOS)
- Mobile (Android, iOS)
- CLI/Scripts Dart

## 🐳 Docker

Se estiver usando Docker:

```dockerfile
FROM dart:stable

# Instalar SQLite
RUN apt-get update && \
    apt-get install -y libsqlite3-dev && \
    apt-get clean

WORKDIR /app
COPY . .

RUN dart pub get

CMD ["dart", "run", "main.dart"]
```

## 📋 Checklist de Instalação

Marque conforme completa:

- [ ] Adicionei `ganki` ao `pubspec.yaml`
- [ ] Executei `dart pub get` ou `flutter pub get`
- [ ] (Linux) Instalei `libsqlite3-dev` se necessário
- [ ] Testei com o exemplo rápido
- [ ] Arquivo `.apkg` foi criado com sucesso
- [ ] Consegui importar no Anki

## 🆘 Ainda com Problemas?

### 1. Verifique a versão do Dart/Flutter

```bash
dart --version
# Deve ser >= 3.0.0

flutter --version
# Deve ser >= 3.0.0
```

### 2. Limpe o cache

```bash
dart pub cache repair
# ou
flutter pub cache repair
```

### 3. Reinstale as dependências

```bash
rm -rf .dart_tool
rm pubspec.lock
dart pub get
```

### 4. Verifique as dependências

Seu `pubspec.yaml` deve ter:

```yaml
dependencies:
  ganki: ^2.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
```

## 📚 Próximos Passos

Instalação concluída? Ótimo! 🎉

1. ✅ Leia o [QUICKSTART.md](QUICKSTART.md) para começar em 5 minutos
2. 📖 Veja o [README.md](README.md) completo
3. 💡 Explore os exemplos em `example/`
4. 🚀 Crie seu primeiro deck!

## 🤝 Contribuindo

Encontrou um problema de instalação não documentado aqui? 

1. Abra uma issue no GitHub
2. Descreva seu sistema operacional e versão do Dart/Flutter
3. Inclua a mensagem de erro completa

Vamos melhorar este guia juntos! 🙌

---

**Ganki** - Pronto para criar decks incríveis! 🎯