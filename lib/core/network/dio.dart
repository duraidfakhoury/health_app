import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://breakingbad.pythonanywhere.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response?> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    Response response;

    // Set headers
    dio.options.headers = {
      'Content-Type': "application/json",
      "Accept": "application/json"
    };

    try {
      // Making the POST request
      response = await dio.post(
        url,
        data: data,
        queryParameters: query,
      );
      return response; // Return the response if successful
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      // Exception specific to Dio errors
      if (e.response != null) {
        // Server responded with an error status code
        // ignore: avoid_print
        print('Error Status Code: ${e.response?.statusCode}');
        // ignore: avoid_print
        print('Error Data: ${e.response?.data}');
        return e.response; // Return the error response if available
      } else {
        // Error due to no response or network issues
        // ignore: avoid_print
        print('Dio Error: ${e.message}');
        return null; // Return null for complete failure
      }
    } catch (e) {
      // Handle any other exceptions
      // ignore: avoid_print
      print('Unexpected Error: $e');
      return null;
    }
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, String> params,
  }) async {
    Response response;
    dio.options.headers = {
      'Content-Type': "application/json ",
      "Accept": "application/json"
    };
    try {
      response = await dio.get(url, queryParameters: query);
      // ignore: avoid_print
      print("respone $response");
    } on DioException catch (e) {
      return e.response!;
    }
    return response;
  }

  // static Future<Response> postData({
  // required String url,
  // data,
  // Map<String, dynamic>? query,
  // }) async {

  // Response response;
  // dio.options.headers = {
  // 'Content-Type': "application/json ",
  // "Accept": "application/json"
  // };
  // try {
  // response = await dio.post(
  // url,
  // data: data,
  // queryParameters: query,
  // );
  // print('response.data ${response.data}');
  // if (response.statusCode == 200) {
  // return response;
  // }
  // } on DioException catch (e) {
  // return e.response!;
  // }
  // return response;
  // }
}
