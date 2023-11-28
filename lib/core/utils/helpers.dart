import 'dart:math';

String generateSuffixForID(int count) {
  final random = Random();
  final result = StringBuffer();

  for (var i = 0; i < count; i++) {
    // Generate a random integer between 65 ('A') and 90 ('Z') inclusive
    final randomCharCode = random.nextInt(26) + 65;

    // Append the corresponding character to the result
    result.writeCharCode(randomCharCode);
  }

  return result.toString();
}

String generatePrefixForID() {
  final milliSinceEpoch = DateTime.now().millisecondsSinceEpoch;
  // random.nextInt(upperBound - lowerBound) + lowerBoun
  final rand = Random().nextInt(1234 - 1000) + 1000;
  const div = 1000000000;
  return (milliSinceEpoch * rand ~/ div).toString();
}
