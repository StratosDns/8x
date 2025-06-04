import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/procedures_provider.dart';
import '../widgets/base_screen.dart';

class ProceduresScreen extends StatefulWidget {
  const ProceduresScreen({super.key});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProceduresProvider>(context, listen: false).fetchProcedures();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Procedures',
      body: Consumer<ProceduresProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.procedures.isEmpty) {
            return const Center(
              child: Text('No procedures found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.procedures.length,
            itemBuilder: (context, index) {
              final procedure = provider.procedures[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Procedure: ${procedure.procedure}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Date: ${procedure.date}'),
                      Text('Provider: ${procedure.provider}'),
                      Text('Location: ${procedure.location}'),
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