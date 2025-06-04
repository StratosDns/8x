// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import providers for state management
import '../providers/dashboard_provider.dart';
import '../providers/user_provider.dart';

// Import widgets
import '../widgets/dashboard_item_title.dart';
import '../widgets/user_info_card.dart';

// Import utility enums
import '../utils/menu_items.dart';

// Import screen navigations
import 'demographics_screen.dart';
import 'allergies_screen.dart';
import 'immunizations_screen.dart';
import 'medication_screen.dart';
import 'problem_list_screen.dart';
import 'procedures_screen.dart';

// MainDashboardScreen is a stateful widget to manage screen-specific state
class MainDashboardScreen extends StatefulWidget {
  // Constructor with optional key
  const MainDashboardScreen({super.key});

  // Create the mutable state for this widget
  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

// State class for MainDashboardScreen
class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Lifecycle method called when the state object is inserted into the widget tree
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the widget is built before fetching data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load initial data for the dashboard
      _loadInitialData();
    });
  }

  // Method to load initial data from providers
  void _loadInitialData() {
    // Fetch user information without listening to changes
    Provider.of<UserProvider>(context, listen: false).fetchUserInfo();

    // Fetch dashboard items, passing context for potential provider access
    Provider.of<DashboardProvider>(context, listen: false).fetchDashboardItems(context);
  }

  // Method to navigate to different screens based on menu item selection
  void _navigateToScreen(MenuItems item) {
    // Select the appropriate screen based on the menu item
    Widget screen;
    switch (item) {
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
      default:
        return;
    }

    // Navigate to the selected screen
    Navigator.push(
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
        title: Container(
          // Decorative container for the title
          decoration: BoxDecoration(
            color: const Color(0xFF10c9b7).withOpacity(0.1),
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
                // Rest of the title
                const TextSpan(
                  text: 'Health Dashboard',
                  style: TextStyle(
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

      // Body using CustomScrollView for advanced scrolling
      body: CustomScrollView(
        slivers: [
          // Welcome message using Selector for efficient updates
          SliverToBoxAdapter(
            child: Selector<UserProvider, String>(
              selector: (context, userProvider) =>
              userProvider.currentUser?.firstName ?? 'User',
              builder: (context, firstName, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome, $firstName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: welcomeBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),

          // User Info Card
          const SliverToBoxAdapter(
            child: UserInfoCard(),
          ),

          // Dashboard Items with loading and error handling
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              // Show loading indicator while fetching data
              if (provider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Show error message if data fetching fails
              if (provider.error != null) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${provider.error}'),
                  ),
                );
              }

              // Create a scrollable list of dashboard items
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = provider.dashboardItems[index];
                    return DashboardItemTile(item: item);
                  },
                  childCount: provider.dashboardItems.length,
                ),
              );
            },
          ),
        ],
      ),

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
                icon: Icons.person,
                title: 'Demographics',
                item: MenuItems.demographics
            ),
            _buildDrawerItem(
                icon: Icons.warning,
                title: 'Allergies',
                item: MenuItems.allergies
            ),
            _buildDrawerItem(
                icon: Icons.medical_services,
                title: 'Immunizations',
                item: MenuItems.immunizations
            ),
            _buildDrawerItem(
                icon: Icons.medication,
                title: 'Medication',
                item: MenuItems.medication
            ),
            _buildDrawerItem(
                icon: Icons.list,
                title: 'Problem List',
                item: MenuItems.problemList
            ),
            _buildDrawerItem(
                icon: Icons.medical_information,
                title: 'Procedures',
                item: MenuItems.procedures
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build drawer menu items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required MenuItems item,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Close the drawer
        Navigator.of(context).pop();
        // Navigate to the selected screen
        _navigateToScreen(item);
      },
    );
  }
}

// Key design patterns and principles:
// 1. Uses Provider for state management
// 2. Implements custom app bar with rich text
// 3. Uses CustomScrollView for flexible scrolling
// 4. Handles loading and error states
// 5. Provides drawer-based navigation
// 6. Separates navigation logic into methods