import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'constants.dart';

class GankiUtils {
  /// Gera um GUID compatível com o Anki baseado nos campos.
  static String guidFor(List<String> values) {
    final hashStr = values.join('__');
    final bytes = utf8.encode(hashStr);
    final digest = sha256.convert(bytes).bytes.sublist(0, 8);

    int hashInt = 0;
    for (var b in digest) {
      hashInt = (hashInt << 8) | b;
    }

    if (hashInt == 0) return base91Table[0];

    var res = StringBuffer();
    var n = hashInt;
    final len = base91Table.length;
    while (n > 0) {
      res.write(base91Table[n % len]);
      n ~/= len;
    }
    // Inverter e retornar
    return res.toString().split('').reversed.join('');
  }

  /// Retorna timestamp em segundos (formato Anki).
  static int timestamp() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  
  /// Retorna timestamp em milissegundos (para IDs).
  static int nowMs() => DateTime.now().millisecondsSinceEpoch;
}