import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/constants/colors.dart';
import 'package:flutter_health_app/constants/images_asset.dart';
import 'package:flutter_health_app/model/FoodContent.dart';
import 'package:flutter_health_app/view/auth/ItemsCubit.dart';
import 'package:flutter_health_app/view/auth/auth_states.dart';
import 'package:flutter_health_app/shared/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  final Map<int, bool> _selectedContents = {};
  List<FoodContent> _items = []; // متغير محلي لتخزين العناصر

  @override
  void initState() {
    context.read<ItemsCubit>().fetchItems();
    super
        .initState(); // تم إضافة super.initState() لأنه من الأفضل استدعاؤها دائمًا.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.purplelight,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImageAsset.backgrounditems),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.beige,
                        size: 30,
                      ),
                    ),
                    // بقية الواجهة هنا
                    Expanded(
                      child: BlocListener<ItemsCubit, ItemsState>(
                        listener: (context, state) {
                          if (state is ItemsSuccess) {
                            // إظهار Snackbar عند نجاح حفظ الحساسية
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                          if (state is ItemsLoaded) {
                            // حفظ العناصر في المتغير المحلي
                            setState(() {
                              _items = state.items;
                            });
                          }
                        },
                        child: BlocBuilder<ItemsCubit, ItemsState>(
                          builder: (context, state) {
                            if (state is ItemsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ItemsError) {
                              return Center(
                                child: Text('Error: ${state.error}'),
                              );
                            } else if (_items.isNotEmpty) {
                              return _buildItemsList(_items);
                            } else {
                              // إعادة محاولة جلب البيانات في حال عدم توفرها
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<ItemsCubit>().fetchItems();
                              });

                              // عرض مؤشر تحميل أثناء إعادة محاولة جلب البيانات
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    // زر الحفظ
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF9764C1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              // طباعة الحساسيات المختارة للتأكد
                              print("Selected Allergies: $_selectedContents");
                              context
                                  .read<ItemsCubit>()
                                  .saveAllergies(_selectedContents);
                            },
                            child: Text(
                              'Save Allergies',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // مساحة أسفل الزر
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(List<FoodContent> contents) {
    print("imaaa");
    print(contents);
    return ListView.builder(
      padding: EdgeInsets.only(top: 195.h),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final content = contents[index];
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.beige,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: ListTile(
            title: CustomText(
              text: content.name,
              textColor: AppColors.blackColor,
              fontSize: 18.sp,
            ),
            trailing: Checkbox(
              value: _selectedContents[content.id] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  _selectedContents[content.id] = value ?? false;
                });
                // طباعة حالة الحساسيات لمعرفة إذا كانت تحدث بشكل صحيح
                print("Selected content ID: ${content.id}, value: $value");
                print("Current selections: $_selectedContents");
              },
            ),
          ),
        );
      },
    );
  }
}
