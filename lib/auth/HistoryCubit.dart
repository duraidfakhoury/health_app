// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/core/network/dio.dart';
import 'package:flutter_health_app/model/HistoryModel%20.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';

class HistoryCubit extends Cubit<List<HistoryModel>> {
  HistoryCubit() : super([]);

  // دالة لجلب البيانات من API
  void getHistory(int userId) {
    DioHelper.getData(
      //الشخصid يحتوي ع  AuthDartCubit.x

      url:
          'https://breakingbad.pythonanywhere.com/api/history/${AuthDartCubit.x}/',
      params: {},
    ).then((value) {
      // ignore: unnecessary_null_comparison
      if (value != null && value.data['success'] == 200) {
        List<HistoryModel> historyList = (value.data['data'] as List)
            .map((item) => HistoryModel.fromJson(item))
            .toList();
        emit(historyList);
      } else {
        emit(
            []); // في حال لم تكن البيانات صحيحة أو لم يُعد الخادم البيانات المتوقعة
      }
    }).catchError((error) {
      // ignore: avoid_print
      print("Error during fetching history: $error");
      emit([]); // في حال وجود خطأ
    });
  }
}
