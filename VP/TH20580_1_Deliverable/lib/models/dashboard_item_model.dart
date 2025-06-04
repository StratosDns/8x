// Import Flutter material package for Widget type
import 'package:flutter/material.dart';

// DashboardItemModel represents an individual item in the dashboard
// This model encapsulates the information needed to display and navigate to different sections
class DashboardItemModel {
  // Title of the dashboard item (e.g., "Allergies", "Medications")
  // Displayed in the dashboard list
  final String title;

  // Path to the icon asset for the dashboard item
  // Used to display a visual representation of the section
  final String icon;

  // Number of items in the specific section
  // Displayed alongside the title to give a quick overview
  final int count;

  // A function that returns a Widget (screen)
  // Used for dynamic navigation to the corresponding screen
  // Allows for lazy loading of screens
  final Widget Function() pageBuilder;

  // Const constructor with required named parameters
  // Ensures all necessary information is provided when creating a dashboard item
  const DashboardItemModel({
    required this.title,
    required this.icon,
    required this.count,
    required this.pageBuilder,
  });
}

// Key Design Principles:
// 1. Immutability
//    - Uses 'final' keyword to prevent modification after creation
//    - Ensures data integrity of dashboard items
//
// 2. Flexibility
//    - Allows dynamic screen creation through pageBuilder
//    - Supports lazy loading of screens
//
// 3. Comprehensive Information
//    - Includes title, icon, count, and screen builder
//    - Provides all necessary information for dashboard representation
//
// 4. Type Safety
//    - Uses strong typing for all properties
//    - Ensures compile-time type checking

// Example Usage:
// DashboardItemModel allergyItem = DashboardItemModel(
//   title: 'Allergies',
//   icon: 'assets/icons/allergies.png',
//   count: 3,
//   pageBuilder: () => AllergiesScreen()
// );


// Use Cases:
// 1. Creating dashboard items with dynamic screen navigation
// 2. Providing a consistent structure for dashboard sections
// 3. Enabling easy addition of new dashboard items