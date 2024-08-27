import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sample_image.dart';

class SampleImageRepository {
  final String baseUrl = 'https://picsum.photos/v2/list';

  Future<List<SampleImage>> fetchImages(
      {required int page, required int limit}) async {
    final response =
        await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SampleImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
