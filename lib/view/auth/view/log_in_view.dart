import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:flutter_health_app/view/auth/auth_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/colors.dart';
import '../../../constants/images_asset.dart';
import '../../../shared/custom_text.dart';
import '../../home_view.dart';
import '../../register_view.dart';

//0962272281
//dd8877@@
class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthDartCubit(),
      child: BlocConsumer<AuthDartCubit, AuthState>(listener: (context, state) {
        if (state is LoginSuccessState) {
          // ignore: avoid_print
          print("successfully login");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
          //  Navigator.pop(context);
        } else if (state is LoginErrorState) {
          // ignore: avoid_print
          print("phone or password not correct");
        }
      }, builder: (BuildContext context, AuthState state) {
        return SafeArea(
          child: Scaffold(
            // backgroundColor: Colors.amber,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImageAsset.backgroundlogin),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 200.h),
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
                            hintText: 'رقم الهاتف',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
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
                          //obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'كلمة المرور',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                // isPasswordVisible
                                // ? Icons.visibility
                                Icons.visibility_off,
                              ),
                              onPressed: () => (),
                              //  context
                              // .read<PasswordVisibilityCubit>()
                              // .toggleVisibility(),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
                          width: 200.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.purpledark,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: ' تسجيل الدخول',
                            ),
                          ),
                        ),
                      ),

                      // ConditionalBuilder(
                      // condition: state is! LoginLoadingState,
                      // builder: (context) => InkWell(
                      // onTap: () {
                      // if (key.currentState!.validate()) {
                      // AuthDartCubit.get(context).userLogin(
                      // phone: phone.text,
                      // password: password.text,
                      // );
                      // }
                      // },
                      // child: Container(
                      // margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
                      // width: 200.w,
                      // height: 40.h,
                      // decoration: BoxDecoration(
                      // color: AppColors.purpledark,
                      // borderRadius: BorderRadius.circular(20.r),
                      // ),
                      // child: const Center(
                      // child: CustomText(
                      // text: ' الدخول',
                      // ),
                      // ),
                      // ),
                      // ),
                      // fallback: (context) => Center(
                      // child: CircularProgressIndicator(),
                      // ),
                      // ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterView()));
                          },
                          child: const CustomText(
                            text: 'ليس لديك حساب ؟',
                            textColor: AppColors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
