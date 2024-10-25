// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_health_app/view/log_in_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // استيراد المكتبة الجديدة
import '../constants/colors.dart';
import '../constants/images_asset.dart';
import '../shared/custom_text.dart';
import 'package:flutter_health_app/core/network/dio.dart'; // Ensure DioHelper is imported

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Controllers to collect user input
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false; // Variable to track loading state
  bool isHovered = false; // Variable to track hover state
  bool _isPasswordVisible = false; // Variable to toggle password visibility
  List<String?> _errorMessages = [
    null,
    null,
    null
  ]; // List to hold error messages

  void _registerUser() {
    final fullName = _fullNameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Reset error messages
    _errorMessages = [null, null, null];

    if (fullName.isEmpty) {
      _errorMessages[0] = "Full Name is required"; // Error for full name
    }
    if (phone.isEmpty) {
      _errorMessages[1] = "Phone Number is required"; // Error for phone number
    }
    if (password.isEmpty) {
      _errorMessages[2] = "Password is required"; // Error for password
    }

    // Check if there are any errors
    if (_errorMessages.any((msg) => msg != null)) {
      setState(() {}); // Update UI to show error messages
      return; // Stop execution if there are errors
    }

    setState(() {
      isLoading = true; // Start loading
    });

    // Call the register function
    DioHelper.postData(
      url: 'register/', // `baseUrl` is already set
      data: {'full_name': fullName, 'phone': phone, 'password': password},
    ).then((value) {
      setState(() {
        isLoading = false; // Stop loading
      });

      if (value?.data['success'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User registered successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogInView()),
        );
      } else {
        // Show error message
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${value?.data['message']}")),
        );
      }
    }).catchError((error) {
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Error: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          // Using Stack to overlay loading indicator
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImageAsset.backgroundlogin),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 170.h),
                child: Column(
                  children: [
                    // Full Name field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.whiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align to the left

                        children: [
                          TextFormField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Full Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          if (_errorMessages[0] !=
                              null) // Show error message if exists
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                _errorMessages[0]!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Phone Number field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.whiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align to the left

                        children: [
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          if (_errorMessages[1] !=
                              null) // Show error message if exists
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                _errorMessages[1]!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Password field with visibility toggle
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.whiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align to the left

                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                        !_isPasswordVisible; // Toggle password visibility
                                  });
                                },
                              ),
                            ),
                          ),
                          if (_errorMessages[2] !=
                              null) // Show error message if exists
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                _errorMessages[2]!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // "Create Account" button
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
                        onTap: isLoading
                            ? null
                            : () {
                                _registerUser();
                              },
                        child: Container(
                          margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
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
                              text: 'Create Account',
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
                                  builder: (context) => const LogInView()));
                        },
                        child: const CustomText(
                          text: 'Already have an account?',
                          textColor: AppColors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: SpinKitChasingDots(
                    // استخدام SpinKitChasingDots بدلاً من CircularProgressIndicator
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
