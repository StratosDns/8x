class MedicationModel {
  final String date;
  final String type;
  final String medicationName;
  final String instructions;
  final String doseQuantityValue;
  final String doseQuantityUnit;
  final String rateQuantityValue;
  final String rateQuantityUnit;
  final String prescriber;

  MedicationModel({
    required this.date,
    required this.type,
    required this.medicationName,
    required this.instructions,
    required this.doseQuantityValue,
    required this.doseQuantityUnit,
    required this.rateQuantityValue,
    required this.rateQuantityUnit,
    required this.prescriber,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      medicationName: json['medicationName'] ?? '',
      instructions: json['instructions'] ?? '',
      doseQuantityValue: json['doseQuantityValue'] ?? '',
      doseQuantityUnit: json['doseQuantityUnit'] ?? '',
      rateQuantityValue: json['rateQuantityValue'] ?? '',
      rateQuantityUnit: json['rateQuantityUnit'] ?? '',
      prescriber: json['prescriber'] ?? '',
    );
  }
}