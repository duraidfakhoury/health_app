// ignore: file_names, depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_health_app/model/FoodContent.dart';
import 'package:flutter_health_app/model/FoodContentRepository.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:flutter_health_app/view/auth/auth_states.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final FoodContentRepository _repository;
  List<FoodContent>? _cachedItems; // لتخزين العناصر محليًا

  ItemsCubit(this._repository) : super(ItemsInitial());

  // جلب العناصر من API
  Future<void> fetchItems() async {
    if (_cachedItems != null) {
      // إذا كانت البيانات موجودة بالفعل، استخدمها مباشرة
      emit(ItemsLoaded(_cachedItems!));
      return;
    }

    try {
      emit(ItemsLoading());
      final items = await _repository.fetchFoodContents();
      _cachedItems = items; // تخزين البيانات محليًا

      if (items.isEmpty) {
        emit(ItemsError('No data available.')); // إظهار رسالة عدم وجود بيانات
      } else {
        emit(ItemsLoaded(items));
      }
    } catch (e) {
      emit(ItemsError(e.toString())); // يمكنك إضافة معلومات إضافية هنا
    }
  }

  // حفظ الحساسيات
  // حفظ الحساسيات
  Future<void> saveAllergies(Map<int, bool> selectedContents) async {
    try {
      for (var entry in selectedContents.entries) {
        if (entry.value) {
          print(AuthDartCubit.x.toString());
          // تحقق مما إذا كانت الحساسية محددة
          final response = await Dio().post(
            'https://breakingbad.pythonanywhere.com/api/users/${AuthDartCubit.x}/food-sensitivities/add/',
            data: {
              "food_content_ids": [2]
            },
          );

          // طباعة محتوى الاستجابة للتأكد مما يتم إرساله من الخادم
          print(response.data);

          if (response.statusCode == 200) {
            // إذا تم الحفظ بنجاح، أظهر رسالة تأكيد
            emit(ItemsSuccess('Successfully saved allergy : ${entry.key}'));
          } else {
            throw Exception("Failed to save allergy for content ${entry.key}");
          }
        }
      }

      // لا حاجة لإعادة جلب البيانات
      emit(ItemsLoaded(_cachedItems!)); // استخدام البيانات المخزنة محليًا
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }
}
