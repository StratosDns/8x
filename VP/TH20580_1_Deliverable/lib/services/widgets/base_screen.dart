// Import necessary Flutter and app-specific dependencies
import 'package:flutter/material.dart';

// Import menu items enum for navigation
import '../utils/menu_items.dart';

// Import all screens for navigation
import '../screens/main_dashboard_screen.dart';
import '../screens/demographics_screen.dart';
import '../screens/allergies_screen.dart';
import '../screens/immunizations_screen.dart';
import '../screens/medication_screen.dart';
import '../screens/problem_list_screen.dart';
import '../screens/procedures_screen.dart';

// BaseScreen is a stateless widget that provides a consistent layout
// and navigation structure for all screens in the application
class BaseScreen extends StatelessWidget {
  // Title of the current screen
  // Displayed in the app bar
  final String title;

  // Main content of the screen
  final Widget body;

  // Optional floating action button
  // Allows customization of screens that might need additional actions
  final Widget? floatingActionButton;

  // Constructor with named parameters
  // 'required' ensures title and body are provided
  // 'floatingActionButton' is optional
  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  // Method to handle navigation between screens
  // Closes the drawer and navigates to the selected screen
  void _navigateToScreen(BuildContext context, MenuItems item) {
    // Close the drawer before navigation
    Navigator.of(context).pop();

    // Select the appropriate screen based on the menu item
    Widget screen;
    switch (item) {
      case MenuItems.home:
      // Special handling for home screen
      // Uses pushAndRemoveUntil to clear the navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainDashboardScreen(),
            settings: const RouteSettings(name: '/'),
          ),
              (route) => false,
        );
        return;
    // Cases for other menu items
      case MenuItems.demographics:
        screen = const DemographicsScreen();
        break;
      case MenuItems.allergies:
        screen = const AllergiesScreen();
        break;
      case MenuItems.immunizations:
        screen = const ImmunizationsScreen();
        break;
      case MenuItems.medication:
        screen = const MedicationScreen();
        break;
      case MenuItems.problemList:
        screen = const ProblemListScreen();
        break;
      case MenuItems.procedures:
        screen = const ProceduresScreen();
        break;
    }

    // Navigate to the selected screen, replacing the current screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the primary color for the app
    final welcomeBlue = Color(0xFF10c9b7);

    return Scaffold(
      // App bar with custom title design
      appBar: AppBar(
        // Removes the default back button
        automaticallyImplyLeading: false,

        // Custom title with a pill-shaped container
        title: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RichText(
            // Rich text to style different parts of the title
            text: TextSpan(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              children: [
                // "My" in a distinct color and larger size
                TextSpan(
                  text: 'My ',
                  style: TextStyle(
                    color: welcomeBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                // Dynamic screen title
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Menu button to open end drawer
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      // Main content of the screen
      body: body,

      // Optional floating action button
      floatingActionButton: floatingActionButton,

      // End drawer for navigation
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header
            DrawerHeader(
              decoration: BoxDecoration(
                color: welcomeBlue,
              ),
              child: const Text(
                'Health Dashboard Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            // Drawer menu items
            _buildDrawerItem(
                context,
                icon: Icons.home,
                title: 'Home',
                item: MenuItems.home
            ),
            _buildDrawerItem(
                context,
                icon: Icons.person,
                title: 'Demographics',
                item: MenuItems.demographics
            ),
            // ... other menu items
          ],
        ),
      ),
    );
  }

  // Helper method to build drawer menu items
  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required MenuItems item,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _navigateToScreen(context, item),
    );
  }
}

// Key Design Patterns and Principles:
// 1. Consistent Layout
//    - Provides a uniform app bar and navigation drawer
//    - Ensures a consistent user experience across screens
//
// 2. Flexible Screen Construction
//    - Accepts custom body and optional floating action button
//    - Allows for screen-specific customization
//
// 3. Centralized Navigation
//    - Manages navigation logic for all screens
//    - Uses an enum to handle different navigation targets
//
// 4. Responsive Design
//    - Uses adaptive widgets and styling
//    - Supports different screen sizes and orientations