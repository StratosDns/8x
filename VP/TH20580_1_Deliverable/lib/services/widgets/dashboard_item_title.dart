// Import Flutter material package for UI widgets
import 'package:flutter/material.dart';

// Import the dashboard item model to define the structure of dashboard items
import '../../models/dashboard_item_model.dart';

// DashboardItemTile is a stateless widget that represents a single item in the dashboard list
// It provides a consistent, styled tile for navigating to different sections of the app
class DashboardItemTile extends StatelessWidget {
  // The dashboard item to be displayed
  // Contains information like title, icon, count, and screen builder
  final DashboardItemModel item;

  // Constructor with a required dashboard item
  // Uses const for performance optimization
  const DashboardItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Customize content padding for consistent spacing
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // Leading widget: Icon/Image
      leading: SizedBox(
        // Fixed size container to control image dimensions
        width: 40,  // Fixed width
        height: 40, // Fixed height
        child: Image.asset(
          item.icon,
          width: 32,  // Slightly smaller than container
          height: 32,
          fit: BoxFit.contain, // Ensure image fits within bounds without distortion
        ),
      ),

      // Title section with vertical bar separator
      title: Row(
        children: [
          // Vertical bar separator
          Text('|',
            style: TextStyle(
              color: Colors.grey.shade400, // Light grey color
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          // Add some horizontal spacing
          const SizedBox(width: 10),

          // Item title
          Text(
            item.title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),

      // Trailing widget: Item count
      trailing: Text(
        '${item.count} items', // Display number of items
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
      ),

      // Navigation on tap
      onTap: () {
        // Navigate to the screen associated with this dashboard item
        Navigator.push(
          context,
          MaterialPageRoute(
            // Use the pageBuilder from the model to create the screen
            builder: (context) => item.pageBuilder(),
          ),
        );
      },
    );
  }
}

// Key Design Principles:
// 1. Immutability
//    - Uses a stateless widget for performance
//    - Relies on immutable DashboardItemModel
//
// 2. Consistent Styling
//    - Predefined text and color styles
//    - Uniform layout for all dashboard items
//
// 3. Flexible Navigation
//    - Uses dynamic pageBuilder for screen creation
//    - Supports lazy loading of screens
//
// 4. Accessibility and Usability
//    - Clear visual hierarchy
//    - Consistent spacing and sizing
//    - Informative item representation

// Example Usage:
// DashboardItemTile(
//   item: DashboardItemModel(
//     title: 'Allergies',
//     icon: 'assets/icons/allergies.png',
//     count: 3,
//     pageBuilder: () => AllergiesScreen()
//   )
// )