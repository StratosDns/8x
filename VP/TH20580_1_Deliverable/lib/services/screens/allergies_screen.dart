// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the allergies provider for state management
import '../providers/allergies_provider.dart';

// Import the base screen widget for consistent screen layout
import '../widgets/base_screen.dart';

// AllergiesScreen is a stateful widget to manage screen-specific state
class AllergiesScreen extends StatefulWidget {
  // Constructor with optional key
  const AllergiesScreen({super.key});

  // Create the mutable state for this widget
  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

// State class for AllergiesScreen
class _AllergiesScreenState extends State<AllergiesScreen> {
  // Called when the state object is inserted into the widget tree
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the widget is built before fetching data
    // This prevents potential timing issues with provider initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch allergies data using the provider
      // 'listen: false' prevents unnecessary rebuilds
      Provider.of<AllergiesProvider>(context, listen: false).fetchAllergies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use BaseScreen for consistent screen layout
    return BaseScreen(
      // Screen title
      title: 'Allergies',

      // Body uses Consumer to listen to AllergiesProvider changes
      body: Consumer<AllergiesProvider>(
        builder: (context, provider, child) {
          // Show loading indicator while data is being fetched
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Display error message if an error occurred during data fetching
          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          // Show message if no allergies are found
          if (provider.allergies.isEmpty) {
            return const Center(
              child: Text('No allergies found'),
            );
          }

          // Build a scrollable list of allergy cards
          return ListView.builder(
            // Add padding around the entire list
            padding: const EdgeInsets.all(16.0),

            // Number of items in the list
            itemCount: provider.allergies.length,

            // Builder method to create each list item
            itemBuilder: (context, index) {
              // Get the current allergy from the provider
              final allergy = provider.allergies[index];

              // Create a card for each allergy
              return Card(
                // Add vertical margin between cards
                margin: const EdgeInsets.symmetric(vertical: 8.0),

                // Add padding inside the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  // Column to arrange allergy details vertically
                  child: Column(
                    // Align content to the start of the column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Allergy name with bold styling
                      Text(
                        'Allergy Name: ${allergy.allergyName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // Add some vertical spacing
                      const SizedBox(height: 8),

                      // Reaction and severity details
                      Text('Reaction: ${allergy.reaction}'),
                      Text('Severity: ${allergy.severity}'),
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

// Key design patterns and principles:
// 1. Uses Provider for state management
// 2. Implements loading, error, and empty states
// 3. Uses BaseScreen for consistent layout
// 4. Asynchronous data fetching in initState
// 5. Responsive UI with conditional rendering