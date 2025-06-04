class UserModel {
  final String id;
  final String name;
  final String profileImagePath;

  UserModel({
    required this.id,
    required this.name,
    this.profileImagePath = 'assets/images/default_profile.png',
  });

  // Method to get first name
  String get firstName {
    // Split the name and return the first part
    List<String> nameParts = name.split(' ');
    return nameParts.isNotEmpty ? nameParts.first : 'User';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImagePath: json['profileImage'] ?? 'assets/images/default_profile.png',
    );
  }
}