import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/demographics_provider.dart';
import '../widgets/base_screen.dart';

class DemographicsScreen extends StatefulWidget {
  const DemographicsScreen({super.key});

  @override
  _DemographicsScreenState createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DemographicsProvider>(context, listen: false).fetchDemographics();
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'Not Specified',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Demographics',
      body: Consumer<DemographicsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          final demographics = provider.demographics;
          if (demographics == null) {
            return const Center(
              child: Text('No demographics information available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('First Name', demographics.firstName),
                _buildInfoRow('Last Name', demographics.lastName),
                _buildInfoRow('Gender', demographics.gender),
                _buildInfoRow('Marital Status', demographics.maritalStatus),
                _buildInfoRow('Religious Affiliation', demographics.religiousAffiliation),
                _buildInfoRow('Ethnicity', demographics.ethnicity),
                _buildInfoRow('Language Spoken', demographics.languageSpoken),
                _buildInfoRow('Address', demographics.address),
                _buildInfoRow('Telephone', demographics.telephone),
                _buildInfoRow('Birthday', demographics.birthday),
              ],
            ),
          );
        },
      ),
    );
  }
}