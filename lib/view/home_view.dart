import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/images_asset.dart';
import '../shared/custom_text.dart';
import 'barcode_scanner_page.dart';
import 'history_view.dart';
import 'items_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImageAsset.backgroundhome),
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 90.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CusttomContainer(
                  text: 'Items', // 'العناصر' -> 'Items'
                  ontap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ItemsView()));
                  },
                ),
                CusttomContainer(
                  text: 'Scanner', // 'الماسح' -> 'Scanner'
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRViewPage()));
                  },
                ),
                CusttomContainer(
                  text: 'History', // 'السجل' -> 'History'
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryView()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CusttomContainer extends StatelessWidget {
  final String text;
  final Function() ontap;

  const CusttomContainer({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
        width: 160.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: CustomText(
            fontSize: 20.sp,
            text: text,
            textColor: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
