// Import Flutter material package for UI widgets
import 'package:flutter/material.dart';

// Import Provider for state management
import 'package:provider/provider.dart';

// Import the user provider to manage user-related state
import '../providers/user_provider.dart';

// UserInfoCard is a stateful widget that displays user information
// It handles loading, error, and user data states
class UserInfoCard extends StatefulWidget {
  // Const constructor with optional key
  const UserInfoCard({super.key});

  // Create the mutable state for this widget
  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

// State class for UserInfoCard
class _UserInfoCardState extends State<UserInfoCard> {
  // Lifecycle method called when the state object is inserted into the widget tree
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the widget is built before fetching data
    // Prevents potential timing issues with provider initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user information using the provider
      // 'listen: false' prevents unnecessary rebuilds
      Provider.of<UserProvider>(context, listen: false).fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to UserProvider changes
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show loading indicator while fetching user data
        if (userProvider.isLoading) {
          return const Card(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Display error message if data fetching fails
        if (userProvider.error != null) {
          return Card(
            child: Center(child: Text('Error: ${userProvider.error}')),
          );
        }

        // Get the current user from the provider
        final user = userProvider.currentUser;

        // Main user info container
        return Container(
          // Margin around the entire card
          margin: const EdgeInsets.all(8.0),

          // Decorative container with color, border radius, and shadow
          decoration: BoxDecoration(
            color: const Color(0xFF10c9b7), // Teal background color
            borderRadius: BorderRadius.circular(15), // Rounded corners
            boxShadow: [
              // Outer shadow for depth effect
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 6), // Shadow position
              ),
            ],
          ),

          // Padding inside the container
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Profile image container
                Container(
                  // Decorative border and shadow for profile image
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      // Inner shadow for image
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // Circular avatar for profile image
                  child: CircleAvatar(
                    radius: 40,
                    // Use user's profile image or default image
                    backgroundImage: AssetImage(user?.profileImagePath ?? 'assets/images/default_profile.png'),
                  ),
                ),

                // Spacing between image and name
                const SizedBox(width: 16),

                // Expanded widget to center the name
                Expanded(
                  child: Center(
                    child: Text(
                      // Display user name or 'Unknown User'
                      user?.name ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Key Design Principles:
// 1. State Management
//    - Uses Provider for reactive user data management
//    - Handles loading and error states
//
// 2. Responsive Design
//    - Adapts to different user data scenarios
//    - Provides fallback for missing data
//
// 3. Visual Hierarchy
//    - Clear separation of profile image and name
//    - Consistent styling and color scheme
//
// 4. Performance Considerations
//    - Uses const constructors
//    - Minimizes rebuilds with 'listen: false'
//
// 5. Error Handling
//    - Displays loading indicator
//    - Shows error message if data fetching fails
//    - Provides default values for missing data
