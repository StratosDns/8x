class DemographicsModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String maritalStatus;
  final String religiousAffiliation;
  final String ethnicity;
  final String languageSpoken;
  final String address;
  final String telephone;
  final String birthday;

  DemographicsModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.maritalStatus,
    required this.religiousAffiliation,
    required this.ethnicity,
    required this.languageSpoken,
    required this.address,
    required this.telephone,
    required this.birthday,
  });

  factory DemographicsModel.fromJson(Map<String, dynamic> json) {
    return DemographicsModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      religiousAffiliation: json['religiousAffiliation'] ?? '',
      ethnicity: json['ethnicity'] ?? '',
      languageSpoken: json['languageSpoken'] ?? '',
      address: json['address'] ?? '',
      telephone: json['telephone'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }
}