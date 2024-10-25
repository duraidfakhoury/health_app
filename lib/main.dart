import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/core/network/dio.dart';
import 'package:flutter_health_app/view/HistoryCubit.dart';
import 'package:flutter_health_app/view/auth/ItemsCubit.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:flutter_health_app/view/log_in_view.dart';
// استيراد ItemsCubit
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_health_app/model/FoodContentRepository.dart'; // استيراد المستودع

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthDartCubit>(
          create: (_) => AuthDartCubit(),
        ),
        BlocProvider<HistoryCubit>(
          create: (_) => HistoryCubit(),
        ),
        BlocProvider<ItemsCubit>(
          // إضافة ItemsCubit هنا
          create: (_) => ItemsCubit(
              FoodContentRepository()), // تمرير المستودع إلى ItemsCubit
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LogInView(),
          );
        },
      ),
    );
  }
}
