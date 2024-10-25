import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/constants/colors.dart';
import 'package:flutter_health_app/model/HistoryModel%20.dart';
// ignore: unused_import
import 'package:flutter_health_app/model/HistoryModel.dart';
import 'package:flutter_health_app/view/HistoryCubit.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/images_asset.dart';
import '../shared/custom_text.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    // Get data from HistoryCubit when the page loads
    context.read<HistoryCubit>().getHistory(
        AuthDartCubit.x); // You can replace 1 with the actual userId
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImageAsset.backgroundhistory),
                fit: BoxFit.fill),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 40,
                ),
              ),
              CustomText(
                text: 'History', // 'السجل' -> 'History'
                textColor: AppColors.blackColor,
                fontSize: 40.sp,
              ),
              SizedBox(height: 15.h),
              const Divider(
                thickness: 2,
                height: 3,
                color: AppColors.blackColor,
                endIndent: 20,
                indent: 10,
              ),
              Expanded(
                child: BlocBuilder<HistoryCubit, List<HistoryModel>>(
                  builder: (context, historyList) {
                    if (historyList.isEmpty) {
                      return const Center(
                        child: CustomText(
                          text:
                              'No data available currently.', // 'لا توجد بيانات حالياً.' -> 'No data available currently.'
                          textColor: AppColors.blackColor,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.only(top: 40.h),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        HistoryModel history = historyList[index];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 170.h,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 7,
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Food ID: ${history.foodId}',
                                  textColor: AppColors.blackColor,
                                ),
                                CustomText(
                                  text: 'Confirmed at: ${history.confirmedAt}',
                                  textColor: AppColors.blackColor,
                                ),
                                CustomText(
                                  text:
                                      'Result: ${history.result ? "Not Sensitive" : "Sensitive"}',
                                  textColor: history.result
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                if (history.sensitiveContents.isNotEmpty)
                                  CustomText(
                                    text:
                                        'Sensitive Contents: ${history.sensitiveContents.join(", ")}',
                                    textColor: AppColors.blackColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
