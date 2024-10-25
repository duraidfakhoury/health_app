import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:flutter_health_app/view/auth/auth_states.dart';
import 'package:flutter_health_app/view/home_view.dart';
import 'package:flutter_health_app/view/register_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // استيراد مكتبة flutter_spinkit
import '../../../constants/colors.dart';
import '../../../constants/images_asset.dart';
import '../../../shared/custom_text.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false; // متغير للتحقق من حالة التحميل
  bool isHovered = false; // متغير للتحقق من حالة التمرير فوق الزر

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthDartCubit(),
      child: BlocConsumer<AuthDartCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          } else if (state is LoginErrorState) {
            setState(() {
              isLoading = false; // انتهاء التحميل في حالة الخطأ
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The phone number or password is incorrect'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (BuildContext context, AuthState state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImageAsset.backgroundlogin),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 200.h),
                      child: Form(
                        key: key,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: AppColors.whiteColor,
                              ),
                              child: TextFormField(
                                controller: phone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.phone),
                                  hintText: 'phone number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: AppColors.whiteColor,
                              ),
                              child: TextFormField(
                                controller: password,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isHovered = false;
                                });
                              },
                              child: InkWell(
                                onTap:
                                    isLoading // تعطيل الزر إذا كان في حالة تحميل
                                        ? null
                                        : () {
                                            if (key.currentState!.validate()) {
                                              setState(() {
                                                isLoading = true; // بدء التحميل
                                              });
                                              // استدعاء دالة userLogin عند النقر على الزر
                                              AuthDartCubit.get(context)
                                                  .userLogin(
                                                phone: phone.text,
                                                password: password.text,
                                              );
                                            }
                                          },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: 25.h, bottom: 10.h),
                                  width: 200.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: isHovered
                                        ? Colors.deepPurpleAccent
                                        : AppColors.purpledark,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: const Center(
                                    child: CustomText(
                                      text: 'Login',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterView()),
                                  );
                                },
                                child: const CustomText(
                                  text: 'Don not you have an account?',
                                  textColor: AppColors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: SpinKitChasingDots(
                          // استخدام SpinKitChasingDots
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
