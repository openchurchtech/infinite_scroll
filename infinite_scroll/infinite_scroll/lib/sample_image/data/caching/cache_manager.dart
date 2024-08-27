import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/sample_image.dart';

class CacheManager {
  static const String _cacheKey = 'cached_images';

  Future<void> saveImages(List<SampleImage> images) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        images.map((image) => image.toJson()).toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
  }

  Future<List<SampleImage>> loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => SampleImage.fromJson(json)).toList();
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
