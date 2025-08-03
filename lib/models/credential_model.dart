import 'package:flutter/material.dart';

class Credential {
  final String id;
  final String platform;
  final String email;
  final String password;
  final CredentialCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Credential({
    required this.id,
    required this.platform,
    required this.email,
    required this.password,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });
}

enum CredentialCategory {
  personal,
  social,
  work,
  banking,
  entertainment,
}

extension CredentialCategoryExtension on CredentialCategory {
  String get displayName {
    switch (this) {
      case CredentialCategory.personal:
        return 'Personal';
      case CredentialCategory.social:
        return 'Social';
      case CredentialCategory.work:
        return 'Work';
      case CredentialCategory.banking:
        return 'Banking';
      case CredentialCategory.entertainment:
        return 'Entertainment';
    }
  }

  Color get color {
    switch (this) {
      case CredentialCategory.personal:
        return Colors.blue;
      case CredentialCategory.social:
        return Colors.pink;
      case CredentialCategory.work:
        return Colors.green;
      case CredentialCategory.banking:
        return Colors.orange;
      case CredentialCategory.entertainment:
        return Colors.purple;
    }
  }
}