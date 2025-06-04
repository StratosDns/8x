import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_list_provider.dart';
import '../widgets/base_screen.dart';

class ProblemListScreen extends StatefulWidget {
  const ProblemListScreen({super.key});

  @override
  _ProblemListScreenState createState() => _ProblemListScreenState();
}

class _ProblemListScreenState extends State<ProblemListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProblemListProvider>(context, listen: false).fetchProblemList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Problem List',
      body: Consumer<ProblemListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.problemList.isEmpty) {
            return const Center(
              child: Text('No problems found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.problemList.length,
            itemBuilder: (context, index) {
              final problem = provider.problemList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observation: ${problem.observation}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Status: ${problem.status}'),
                      Text('Date: ${problem.date}'),
                      Text('Comments: ${problem.comments}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}