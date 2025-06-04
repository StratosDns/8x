class ImmunizationModel {
  final String date;
  final String immunizationName;
  final String type;
  final String doseQuantityValue;
  final String doseQuantityUnit;
  final String educationInstructions;

  ImmunizationModel({
    required this.date,
    required this.immunizationName,
    required this.type,
    required this.doseQuantityValue,
    required this.doseQuantityUnit,
    required this.educationInstructions,
  });

  factory ImmunizationModel.fromJson(Map<String, dynamic> json) {
    return ImmunizationModel(
      date: json['date'] ?? '',
      immunizationName: json['immunizationName'] ?? '',
      type: json['type'] ?? '',
      doseQuantityValue: json['doseQuantityValue'] ?? '',
      doseQuantityUnit: json['doseQuantityUnit'] ?? '',
      educationInstructions: json['educationInstructions'] ?? '',
    );
  }
}