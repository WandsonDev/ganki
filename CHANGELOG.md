# Changelog

All notable changes to the Ganki project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-15

### Added
- Initial release of Ganki library
- Core functionality:
  - `Model` class for defining note types
  - `Note` class for creating flashcard content
  - `Card` class for individual cards
  - `Deck` class for organizing notes
  - `Package` class for generating .apkg files
- Built-in models:
  - Basic Model
  - Basic and Reversed Card Model
  - Basic Optional Reversed Card Model
  - Basic Type in the Answer Model
  - Cloze Model
- Utility functions:
  - `guidFor()` for generating unique GUIDs
  - `escapeHtml()` for HTML escaping
- Support for:
  - Front/Back cards
  - Cloze deletion cards
  - Custom models with CSS styling
  - Multiple templates per model
  - Media files (audio, images)
  - Multiple decks in single package
  - Tags for notes
  - Custom sort fields
- Full compatibility with Anki 2.1+
- Comprehensive documentation and examples
- Unit tests for core functionality

### Dependencies
- archive ^3.6.1 - ZIP file creation
- sqlite3 ^2.4.6 - Database management
- mustache_template ^2.0.0 - Template rendering
- crypto ^3.0.3 - GUID generation
- path ^1.9.0 - File path utilities

## [Unreleased]

### Planned
- Support for reading/importing existing .apkg files
- Bulk import utilities
- More built-in models
- Enhanced error messages
- Performance optimizations
- Web platform support