extension StringX on String {
  String get firstword {
    final words = trim().split(' ');

    // Remove every word after the first one
    for (var i = 1; i < words.length; i++) {
      words[i] = '';
    }

    return words.join(' ');
  }

  bool get isEmail {
    // Regular expression for a simple email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    return emailRegex.hasMatch(this);
  }

  String sortChars() {
    final charList = split('')..sort();
    return charList.join();
  }

  bool get isValidMid {
    // Define a regular expression for the desired format
    final regex = RegExp(r'^\d{6,7}[A-Z]{2}$');

    // Use the regular expression to check the format
    return regex.hasMatch(this);
  }
}
