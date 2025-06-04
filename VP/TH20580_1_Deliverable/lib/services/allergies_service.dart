// Import the AllergyModel to define the structure of allergy data
import '../models/allergy_model.dart';

// AllergiesService provides methods for retrieving allergy information
class AllergiesService {
  // Asynchronous method to fetch allergies
  // Returns a Future list of AllergyModel objects
  Future<List<AllergyModel>> fetchAllergies() async {
    // Simulate a network delay to mimic real-world API call
    // This helps in showing loading states and testing asynchronous behavior
    await Future.delayed(const Duration(seconds: 1));

    // Return a hardcoded list of allergies
    // In a real-world scenario, this would be replaced with an actual API call
    return [
      // First allergy entry
      AllergyModel(
        allergyName: 'Penicillin', // Name of the allergen
        reaction: 'Hives', // Specific reaction to the allergen
        severity: 'Moderate to severe', // Severity of the allergic reaction
      ),

      // Second allergy entry
      AllergyModel(
        allergyName: 'Codeine',
        reaction: 'Shortness of Breath',
        severity: 'Moderate',
      ),

      // Third allergy entry
      AllergyModel(
        allergyName: 'Bee Stings',
        reaction: 'Anaphylactic Shock',
        severity: 'Severe',
      ),
    ];
  }
}

// Key points about this service:
// 1. Provides mock data for allergies
// 2. Simulates asynchronous data fetching
// 3. Can be easily replaced with real API calls in the future
// 4. Follows the service pattern of separating data retrieval logic