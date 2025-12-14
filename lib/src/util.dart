import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Base91 table for encoding GUIDs
const List<String> base91Table = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '!',
  '#',
  r'$',
  '%',
  '&',
  '(',
  ')',
  '*',
  '+',
  ',',
  '.',
  '/',
  ':',
  ';',
  '<',
  '=',
  '>',
  '?',
  '@',
  '[',
  ']',
  '^',
  '_',
  '`',
  '{',
  '|',
  '}',
  '~'
];

/// Generate a GUID for the given values using SHA256 hash and Base91 encoding
String guidFor(List<dynamic> values) {
  final hashStr = values.map((v) => v.toString()).join('__');
  final bytes = utf8.encode(hashStr);
  final digest = sha256.convert(bytes);
  final hashBytes = digest.bytes.sublist(0, 8);

  int hashInt = 0;
  for (final b in hashBytes) {
    hashInt = (hashInt << 8) + b;
  }

  final List<String> rvReversed = [];
  while (hashInt > 0) {
    rvReversed.add(base91Table[hashInt % base91Table.length]);
    hashInt ~/= base91Table.length;
  }

  return rvReversed.reversed.join();
}

/// Escape HTML special characters
String escapeHtml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#x27;');
}
