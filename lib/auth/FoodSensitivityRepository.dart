// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter_health_app/model/FoodSensitivity.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';

class FoodSensitivityRepository {
  final Dio _dio = Dio();

  Future<void> saveFoodSensitivity(FoodSensitivity sensitivity) async {
    final response = await _dio.post(
      'https://breakingbad.pythonanywhere.com/api/users/${AuthDartCubit.x}/food-sensitivities/add/',
      data: {
        'food_content': [1],
        //sensitivity.foodContentId,
        // 'is_allergic': sensitivity.isAllergic,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error saving food sensitivity: ${response.statusCode}');
    }
  }
}
