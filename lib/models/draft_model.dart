import 'package:intl/intl.dart';

class Draft {
  final String password;
  final DateTime createdAt;

  Draft({
    required this.password,
    required this.createdAt,
  });

  String get formattedDate {
    return DateFormat('hh:mm a | dd MMM yyyy').format(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}