// AllergyModel represents the data structure for an individual allergy
class AllergyModel {
  // Immutable properties of an allergy
  // 'final' ensures that these values cannot be changed after initialization

  // Name of the allergy (e.g., "Penicillin", "Peanuts")
  final String allergyName;

  // Specific reaction to the allergen (e.g., "Hives", "Anaphylaxis")
  final String reaction;

  // Severity of the allergic reaction (e.g., "Mild", "Moderate", "Severe")
  final String severity;

  // Constructor with required named parameters
  // 'required' ensures that all fields must be provided when creating an instance
  AllergyModel({
    required this.allergyName,
    required this.reaction,
    required this.severity,
  });

  // Factory constructor to create an AllergyModel from a JSON map
  // Useful for parsing data from external sources (e.g., API responses)
  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      // Use null-aware operator (??) to provide default empty string 
      // if the key is not found in the JSON
      allergyName: json['allergyName'] ?? '',
      reaction: json['reaction'] ?? '',
      severity: json['severity'] ?? '',
    );
  }
}

// Key Design Principles:
// 1. Immutability
//    - Uses 'final' keyword to prevent modification after creation
//    - Ensures data integrity
//
// 2. Data Validation
//    - Required parameters in constructor
//    - Null-safe default values in fromJson method
//
// 3. Serialization Support
//    - Provides factory constructor for JSON parsing
//    - Allows easy conversion from different data sources
//
// 4. Encapsulation
//    - Keeps allergy data private and controlled
//    - Provides a clean, type-safe way to represent allergy information

// Example Usage:
// 1. Creating a direct instance:
// var allergy = AllergyModel(
//   allergyName: 'Penicillin',
//   reaction: 'Hives',
//   severity: 'Moderate'
// );
//
// 2. Creating from JSON:
// var allergyFromJson = AllergyModel.fromJson({
//   'allergyName': 'Peanuts',
//   'reaction': 'Swelling',
//   'severity': 'Severe'
// });

