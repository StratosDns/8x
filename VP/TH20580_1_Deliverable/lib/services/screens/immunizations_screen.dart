import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/immunizations_provider.dart';
import '../widgets/base_screen.dart';

class ImmunizationsScreen extends StatefulWidget {
  const ImmunizationsScreen({super.key});

  @override
  _ImmunizationsScreenState createState() => _ImmunizationsScreenState();
}

class _ImmunizationsScreenState extends State<ImmunizationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ImmunizationsProvider>(context, listen: false).fetchImmunizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Immunizations',
      body: Consumer<ImmunizationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.immunizations.isEmpty) {
            return const Center(
              child: Text('No immunizations found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.immunizations.length,
            itemBuilder: (context, index) {
              final immunization = provider.immunizations[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${immunization.date}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Immunization Name: ${immunization.immunizationName}'),
                      Text('Type: ${immunization.type}'),
                      Text('Dose Quantity: ${immunization.doseQuantityValue} ${immunization.doseQuantityUnit}'),
                      Text('Education/Instructions: ${immunization.educationInstructions}'),
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