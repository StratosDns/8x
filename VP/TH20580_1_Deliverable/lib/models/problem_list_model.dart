class ProblemListModel {
  final String observation;
  final String status;
  final String date;
  final String comments;

  ProblemListModel({
    required this.observation,
    required this.status,
    required this.date,
    required this.comments,
  });

  factory ProblemListModel.fromJson(Map<String, dynamic> json) {
    return ProblemListModel(
      observation: json['observation'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      comments: json['comments'] ?? '',
    );
  }
}