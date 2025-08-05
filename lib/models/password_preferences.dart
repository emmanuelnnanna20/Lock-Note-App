class PasswordPreferences {
  bool includeLowercase;
  bool includeUppercase;
  bool includeNumbers;
  bool includeSymbols;
  int length;

  PasswordPreferences({
    this.includeLowercase = true,
    this.includeUppercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.length = 12,
  });

  Map<String, dynamic> toJson() {
    return {
      'includeLowercase': includeLowercase,
      'includeUppercase': includeUppercase,
      'includeNumbers': includeNumbers,
      'includeSymbols': includeSymbols,
      'length': length,
    };
  }

  factory PasswordPreferences.fromJson(Map<String, dynamic> json) {
    return PasswordPreferences(
      includeLowercase: json['includeLowercase'] ?? true,
      includeUppercase: json['includeUppercase'] ?? true,
      includeNumbers: json['includeNumbers'] ?? true,
      includeSymbols: json['includeSymbols'] ?? true,
      length: json['length'] ?? 12,
    );
  }

  PasswordPreferences copyWith({
    bool? includeLowercase,
    bool? includeUppercase,
    bool? includeNumbers,
    bool? includeSymbols,
    int? length,
  }) {
    return PasswordPreferences(
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
      length: length ?? this.length,
    );
  }
}