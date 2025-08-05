import 'dart:math';
import 'package:locknote/models/password_preferences.dart';

class PasswordService {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generatePassword(PasswordPreferences preferences) {
    if (preferences.length < 1) return '';
    
    String characterPool = '';
    List<String> requiredChars = [];
    
    // Build character pool and ensure at least one character from each selected category
    if (preferences.includeLowercase) {
      characterPool += _lowercase;
      requiredChars.add(_getRandomChar(_lowercase));
    }
    
    if (preferences.includeUppercase) {
      characterPool += _uppercase;
      requiredChars.add(_getRandomChar(_uppercase));
    }
    
    if (preferences.includeNumbers) {
      characterPool += _numbers;
      requiredChars.add(_getRandomChar(_numbers));
    }
    
    if (preferences.includeSymbols) {
      characterPool += _symbols;
      requiredChars.add(_getRandomChar(_symbols));
    }
    
    // If no character types are selected, default to lowercase
    if (characterPool.isEmpty) {
      characterPool = _lowercase;
      requiredChars.add(_getRandomChar(_lowercase));
    }
    
    // Generate the rest of the password
    final random = Random.secure();
    final password = StringBuffer();
    
    // Add required characters first
    for (String char in requiredChars) {
      password.write(char);
    }
    
    // Fill the remaining length with random characters from the pool
    int remainingLength = preferences.length - requiredChars.length;
    for (int i = 0; i < remainingLength; i++) {
      password.write(characterPool[random.nextInt(characterPool.length)]);
    }
    
    // Shuffle the password to avoid predictable patterns
    return _shuffleString(password.toString());
  }
  
  static String _getRandomChar(String characterSet) {
    final random = Random.secure();
    return characterSet[random.nextInt(characterSet.length)];
  }
  
  static String _shuffleString(String input) {
    final random = Random.secure();
    List<String> chars = input.split('');
    
    // Fisher-Yates shuffle algorithm
    for (int i = chars.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      String temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }
    
    return chars.join('');
  }
  
  // Calculate password strength (optional utility method)
  static PasswordStrength calculateStrength(String password, PasswordPreferences preferences) {
    int score = 0;
    
    // Length scoring
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;
    
    // Character type scoring
    if (preferences.includeLowercase && password.contains(RegExp(r'[a-z]'))) score += 1;
    if (preferences.includeUppercase && password.contains(RegExp(r'[A-Z]'))) score += 1;
    if (preferences.includeNumbers && password.contains(RegExp(r'[0-9]'))) score += 1;
    if (preferences.includeSymbols && password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) score += 1;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 6) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}