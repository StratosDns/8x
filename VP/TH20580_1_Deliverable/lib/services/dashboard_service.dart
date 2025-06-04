class DashboardService {
  // In a real-world scenario, this would fetch data from an API
  Future<List<Map<String, dynamic>>> fetchDashboardItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'title': 'Allergies',
        'icon': 'assets/images/logo.png',
        'count': 3,
      },
      {
        'title': 'Immunizations',
        'icon': 'assets/images/logo.png',
        'count': 5,
      },
      // Add more items as needed
    ];
  }
}