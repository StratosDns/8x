// lib/models/health_record.dart
class HealthRecord {
  final String id;
  final String username;  // Add this field
  final String imagePath;
  final String category;
  final DateTime dateCreated;

  HealthRecord({
    required this.id,
    required this.username,  // Add this
    required this.imagePath,
    required this.category,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,  // Add this
    'imagePath': imagePath,
    'category': category,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory HealthRecord.fromJson(Map<String, dynamic> json) => HealthRecord(
    id: json['id'],
    username: json['username'],  // Add this
    imagePath: json['imagePath'],
    category: json['category'],
    dateCreated: DateTime.parse(json['dateCreated']),
  );
}