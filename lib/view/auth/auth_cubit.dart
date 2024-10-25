import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/core/network/dio.dart';

import 'auth_states.dart';

class AuthDartCubit extends Cubit<AuthState> {
  AuthDartCubit() : super(AuthDartInitial());

  static AuthDartCubit get(context) => BlocProvider.of(context);
  //id يقوم ب تخزين الشخص x
  static int x = 0;
  void userLogin({required String phone, required String password}) {
    // ignore: avoid_print
    print("Trying to log in with phone: $phone and password: $password");

    DioHelper.postData(
      url: 'https://breakingbad.pythonanywhere.com/api/login/',
      data: {'phone': phone, 'password': password},
    ).then((value) {
      // value.data['data'];
      // ignore: avoid_print
      print('Response: ${value!.data}'); // طباعة الاستجابة

      x = value.data['data']['id'];

      if (value.data.containsKey('success') &&
          value.data.containsKey('message')) {
        if (value.data['success'] == true) {
          emit(LoginSuccessState());
        } else {
          emit(LoginErrorState(value.data['message']));
          // ignore: avoid_print
          print("Login Error: ${value.data['message']}");
        }
      } else {
        emit(LoginErrorState("استجابة غير صالحة من الخادم"));
      }
    }).catchError((onError) {
      // ignore: avoid_print
      print("Error during login: $onError");
      emit(LoginErrorState(onError.toString()));
    });
  }

  void userRegister({
    required String fullName,
    required String phone,
    required String password,
  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(
      url: 'https://breakingbad.pythonanywhere.com/api/register/',
      data: {'full_name': fullName, 'phone': phone, 'password': password},
    ).then((value) {
      emit(RegisterLoadingState());
      // ignore: avoid_print
      print(value!.data!.toString());
    }).catchError((onError) {
      // ignore: avoid_print
      print(onError.toString());
      emit(RegisterErrorState(onError.toString()));
    });
  }
}
