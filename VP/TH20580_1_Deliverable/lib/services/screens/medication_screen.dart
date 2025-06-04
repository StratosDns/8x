import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../widgets/base_screen.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicationProvider>(context, listen: false).fetchMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Medication',
      body: Consumer<MedicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.medications.isEmpty) {
            return const Center(
              child: Text('No medications found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.medications.length,
            itemBuilder: (context, index) {
              final medication = provider.medications[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${medication.date}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Type: ${medication.type}'),
                      Text('Name of Medication: ${medication.medicationName}'),
                      Text('Instructions: ${medication.instructions}'),
                      Text('Dose Quantity: ${medication.doseQuantityValue} ${medication.doseQuantityUnit}'),
                      Text('Rate Quantity: ${medication.rateQuantityValue} ${medication.rateQuantityUnit}'),
                      Text('Name of Prescriber: ${medication.prescriber}'),
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