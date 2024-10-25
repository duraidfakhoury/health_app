import 'package:dio/dio.dart';
import 'package:flutter_health_app/model/FoodContent.dart';

class FoodContentRepository {
  final Dio _dio = Dio();

  Future<List<FoodContent>> fetchFoodContents() async {
    try {
      final response = await _dio
          .get('https://breakingbad.pythonanywhere.com/api/food-contents/');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;

        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          List<dynamic> data = jsonData['data'];
          return data.map((json) => FoodContent.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load food contents');
      }
    } catch (e) {
      throw Exception('Error fetching food contents: $e');
    }
  }
}
