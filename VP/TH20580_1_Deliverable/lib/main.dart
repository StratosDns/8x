// Import necessary providers for state management
import 'package:askisi1/services/providers/allergies_provider.dart';
import 'package:askisi1/services/providers/dashboard_provider.dart';
import 'package:askisi1/services/providers/demographics_provider.dart';
import 'package:askisi1/services/providers/immunizations_provider.dart';
import 'package:askisi1/services/providers/medication_provider.dart';
import 'package:askisi1/services/providers/problem_list_provider.dart';
import 'package:askisi1/services/providers/procedures_provider.dart';
import 'package:askisi1/services/providers/user_provider.dart';

// Import splash screen
import 'package:askisi1/services/screens/splash_screen.dart';

// Import Flutter and Provider packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main entry point of the application
void main() {
  // Run the app with multiple providers for global state management
  runApp(
    // MultiProvider allows multiple providers to be used throughout the app
    MultiProvider(
      // List of providers that will be available to the entire app
      providers: [
        // Each provider manages the state for a specific section of the app
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AllergiesProvider()),
        ChangeNotifierProvider(create: (_) => ImmunizationsProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ProblemListProvider()),
        ChangeNotifierProvider(create: (_) => ProceduresProvider()),
        ChangeNotifierProvider(create: (_) => DemographicsProvider()),
      ],
      // The root widget of the application
      child: const MyApp(),
    ),
  );
}

// Root application widget
class MyApp extends StatelessWidget {
  // Constructor with key parameter
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title displayed in recent apps
      title: 'Health Dashboard',

      // App-wide theme configuration
      theme: ThemeData(
        // Primary color swatch for the app
        primarySwatch: Colors.blue,

        // Ensures the app looks good on different device densities
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Initial screen when the app launches
      // SplashScreen provides a brief introduction before main dashboard
      home: const SplashScreen(),
    );
  }
}