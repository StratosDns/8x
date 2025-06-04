// lib/services/health_record_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/health_record.dart';

class HealthRecordService {
  static const String _recordsKey = 'health_records';

  // Save image and record
  static Future<HealthRecord> saveHealthRecord(
      File image,
      String category,
      String username,  // Add username parameter
      ) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedImage = await image.copy('${appDir.path}/$fileName');

      final record = HealthRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,  // Add username
        imagePath: savedImage.path,
        category: category,
        dateCreated: DateTime.now(),
      );

      final records = await getAllRecords();
      records.add(record);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _recordsKey,
        json.encode(records.map((r) => r.toJson()).toList()),
      );

      return record;
    } catch (e) {
      print('Error saving health record: $e');
      throw Exception('Failed to save health record');
    }
  }

  // Get records for specific user
  static Future<List<HealthRecord>> getRecordsForUser(String username) async {
    try {
      final allRecords = await getAllRecords();
      return allRecords.where((record) => record.username == username).toList();
    } catch (e) {
      print('Error getting user records: $e');
      return [];
    }
  }

  // Get all records (private method)
  static Future<List<HealthRecord>> getAllRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getString(_recordsKey);
      if (recordsJson == null) return [];

      final recordsList = json.decode(recordsJson) as List;
      return recordsList
          .map((record) => HealthRecord.fromJson(record as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting health records: $e');
      return [];
    }
  }

  // Delete record (with user verification)
  static Future<bool> deleteRecord(HealthRecord record, String username) async {
    try {
      // Verify the record belongs to the user
      if (record.username != username) {
        throw Exception('Unauthorized to delete this record');
      }

      final imageFile = File(record.imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      final records = await getAllRecords();
      records.removeWhere((r) => r.id == record.id && r.username == username);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _recordsKey,
        json.encode(records.map((r) => r.toJson()).toList()),
      );

      return true;
    } catch (e) {
      print('Error deleting health record: $e');
      return false;
    }
  }
}