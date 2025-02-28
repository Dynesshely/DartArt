import 'package:dart_art/dart_art.dart';

void main() {
  var size = BinarySize()..bytesCount = BigInt.from(1024);

  print(size.displayText); // 1.00 KB
}
