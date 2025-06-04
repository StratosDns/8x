// Import Flutter foundation for ChangeNotifier
import 'package:flutter/foundation.dart';

// Import the AllergyModel to define the structure of allergy data
import '../../models/allergy_model.dart';

// Import the AllergiesService to fetch allergy data
import '../allergies_service.dart';

// AllergiesProvider manages the state of allergies data
// Uses ChangeNotifier to enable reactive state management
class AllergiesProvider with ChangeNotifier {
  // Private list to store allergy models
  List<AllergyModel> _allergies = [];

  // Private loading state flag
  bool _isLoading = false;

  // Private error state to handle potential errors
  String? _error;

  // Getter for allergies list - allows read-only access
  List<AllergyModel> get allergies => _allergies;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for error state
  String? get error => _error;

  // Service to fetch allergies data
  final AllergiesService _allergiesService = AllergiesService();

  // Asynchronous method to fetch allergies
  Future<void> fetchAllergies() async {
    try {
      // Set loading state to true
      _isLoading = true;

      // Notify listeners that state has changed
      // This will trigger UI updates
      notifyListeners();

      // Fetch allergies using the allergies service
      _allergies = await _allergiesService.fetchAllergies();

      // Set loading state to false
      _isLoading = false;

      // Clear any previous errors
      _error = null;

      // Notify listeners of the successful data fetch
      notifyListeners();
    } catch (e) {
      // If an error occurs during data fetching
      // Store the error message
      _error = e.toString();

      // Set loading state to false
      _isLoading = false;

      // Notify listeners of the error state
      notifyListeners();
    }
  }
}

// Key design patterns and principles:
// 1. State Management:
//    - Uses ChangeNotifier for reactive state updates
//    - Provides getters for controlled access to private fields
//
// 2. Error Handling:
//    - Catches and stores potential errors
//    - Provides error state for UI to react
//
// 3. Asynchronous Data Fetching:
//    - Uses async/await for non-blocking data retrieval
//    - Manages loading states during data fetch
//
// 4. Separation of Concerns:
//    - Delegates data fetching to a service
//    - Focuses on state management and UI coordination
//
// 5. Reactive Programming:
//    - Uses notifyListeners() to trigger UI updates
//    - Provides a clean way to update UI based on data state