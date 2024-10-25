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
  Future<void> saveAllergies(Map<int, bool> selectedContents) async {
    try {
      // جمع كل العناصر المحددة في قائمة
      final List<int> foodContentIds = [];

      for (var entry in selectedContents.entries) {
        if (entry.value) {
          foodContentIds.add(entry.key); // إضافة المعرف إلى القائمة
        }
      }

      // تحقق مما إذا كانت القائمة غير فارغة
      if (foodContentIds.isNotEmpty) {
        // إرسال الطلب مع كل العناصر المحددة دفعة واحدة
        final response = await Dio().post(
          'https://breakingbad.pythonanywhere.com/api/users/${AuthDartCubit.x}/food-sensitivities/add/',
          data: {
            "food_content_ids": foodContentIds // إرسال القائمة الكاملة
          },
        );

        // طباعة محتوى الاستجابة للتأكد مما يتم إرساله من الخادم

        if (response.statusCode == 201) {
          // إذا تم الحفظ بنجاح، أظهر رسالة تأكيد
          emit(ItemsSuccess(
              'Successfully saved allergies: ${foodContentIds.join(', ')}'));
        } else {
          throw Exception(
              "Failed to save allergies for contents: ${foodContentIds.join(', ')}");
        }
      } else {
        emit(ItemsSuccess('No allergies selected to save.'));
      }

      // لا حاجة لإعادة جلب البيانات
      emit(ItemsLoaded(_cachedItems!)); // استخدام البيانات المخزنة محليًا
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  // حفظ الحساسيات
  /*  Future<void> saveAllergies(Map<int, bool> selectedContents) async {
    try {
      for (var entry in selectedContents.entries) {
        if (entry.value) {
          // تحقق مما إذا كانت الحساسية محددة
          final response = await Dio().post(
            'https://breakingbad.pythonanywhere.com/api/users/4/food-sensitivities/add/',
            data: {
              "food_content_ids": [entry.key]
            },
          );

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
  }*/
}
