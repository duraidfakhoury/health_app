// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter_health_app/model/Food.dart';

class FoodRepository {
  final Dio _dio = Dio();

  Future<List<Food>> fetchFoods() async {
    final response =
        await _dio.get('https://breakingbad.pythonanywhere.com/api/foods/1/');

    if (response.statusCode == 200) {
      List<Food> foods = [];
      foods.add(Food.fromJson(response.data['data']));
      return foods;
    } else {
      throw Exception('Failed to load foods');
    }
  }
}
