import '../models/problem_list_model.dart';

class ProblemListService {
  Future<List<ProblemListModel>> fetchProblemList() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      ProblemListModel(
        observation: 'Ankle Sprain',
        status: 'Active',
        date: 'March 28, 2005',
        comments: 'Slipped on ice and fell.',
      ),
      ProblemListModel(
        observation: 'Cholecystitis',
        status: 'Resolved',
        date: 'September 28, 2002',
        comments: 'Surgery postponed until after delivery  ',
      ),
    ];
  }
}