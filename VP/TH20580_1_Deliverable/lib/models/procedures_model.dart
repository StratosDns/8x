class ProceduresModel {
  final String procedure;
  final String date;
  final String provider;
  final String location;

  ProceduresModel({
    required this.procedure,
    required this.date,
    required this.provider,
    required this.location,
  });

  factory ProceduresModel.fromJson(Map<String, dynamic> json) {
    return ProceduresModel(
      procedure: json['procedure'] ?? '',
      date: json['date'] ?? '',
      provider: json['provider'] ?? '',
      location: json['location'] ?? '',
    );
  }
}