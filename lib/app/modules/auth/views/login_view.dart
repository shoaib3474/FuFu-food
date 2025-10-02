// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/auth_controller.dart';
import 'forget_password_view.dart';
import 'phone_number_view.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final splashController = Get.find<SplashController>();
  final authController = Get.put(AuthController());

  bool passwordVisible = true;
  bool rememberMe = false;

  // Colors to match the mock
  static const _bg = Color(0xFF0B0B0B);
  static const _yellow = Color(0xFFFFD600);
  static const _subtle = Color(0xFFB7B7B7);
  static const _field = Color(0xFF3A3A3A);
  static const _accent = Color(0xFFE65A2A);

  @override
  void initState() {
    super.initState();
    rememberMe = box.read('remember') ?? false;

    if (rememberMe) {
      authController.emailController.text = box.read('email') ?? "";
    } else {
      box.remove('email');
      box.remove('password');
      authController.emailController.clear();
      authController.passwordController.clear();
    }

    if (splashController.configData.demo == true) {
      authController.emailController.text = "customer@example.com";
      authController.passwordController.text = "123456";
    }
  }

  OutlineInputBorder _noBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.r),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Stack(
        children: [
          Scaffold(
            backgroundColor: _bg,
            // EXACTLY SAME APP BAR STYLE AS MOCK
            appBar: AppBar(
              backgroundColor: _bg,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "LOGIN".tr,
                style: TextStyle(
                  color: _yellow,
                  fontWeight: FontWeight.w800,
                  fontSize: 20.sp,
                ),
              ),
              leading: IconButton(
                icon: SvgPicture.asset(
                  Images.back,
                  colorFilter: const ColorFilter.mode(_yellow, BlendMode.srcIn),
                ),
                onPressed: Get.back,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome
                          Text(
                            "WELCOME_BACK".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Email / Mobile
                          Text(
                            "EMAIL_OR_MOBILE".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: authController.emailController,
                            style: const TextStyle(color: Colors.white),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? "Required" : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _field,
                              hintText: "USER_EXAMPLE_EMAIL".tr,
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: _noBorder(),
                              enabledBorder: _noBorder(),
                              focusedBorder: _noBorder(),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Password
                          Text(
                            "PASSWORD".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: authController.passwordController,
                            obscureText: passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            validator: (v) => (v == null || v.length < 6)
                                ? "PASSWORD_MUST_BE_SIX".tr
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _field,
                              hintText: "••••••••••••",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                letterSpacing: 2,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: _noBorder(),
                              enabledBorder: _noBorder(),
                              focusedBorder: _noBorder(),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => passwordVisible = !passwordVisible,
                                ),
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: _accent,
                                ),
                              ),
                            ),
                          ),

                          // Forgot
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Get.to(
                                () => const ForgetPasswordView(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 350),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(top: 8.h),
                              ),
                              child: Text(
                                "FORGOT_PASSWORD".tr,
                                style: TextStyle(
                                  color: _accent,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),

                          // Primary CTA
                          SizedBox(height: 6.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  authController.login(
                                    authController.emailController.text,
                                    authController.passwordController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                              ),
                              child: Text(
                                "LOGIN".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),

                          // LOGIN AS GUEST (added, matches style)
                          if (splashController.configData.siteGuestLogin !=
                              10) ...[
                            SizedBox(height: 12.h),
                            SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: OutlinedButton(
                                onPressed: () => Get.to(
                                  () => PhoneNumberView(isGuest: true),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 350),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: _accent,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.r),
                                  ),
                                  backgroundColor: _bg,
                                ),
                                child: Text(
                                  "LOGIN_AS_GUEST".tr,
                                  style: TextStyle(
                                    color: _accent,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // Social
                          SizedBox(height: 18.h),
                          // Center(
                          //   child: Text("or sign up with",
                          //       style: TextStyle(color: _subtle, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                          // ),
                          // SizedBox(height: 12.h),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     _SocialCircle(label: "G", onTap: () {}),
                          //     SizedBox(width: 14.w),
                          //     _SocialCircle(label: "f", onTap: () {}),
                          //     SizedBox(width: 14.w),
                          //     _SocialCircle(icon: Icons.fingerprint, onTap: () {}),
                          //   ],
                          // ),

                          // Bottom Sign up
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "DONT_HAVE_AN_ACCOUNT".tr,
                                style: TextStyle(
                                  color: _subtle,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              InkWell(
                                onTap: () => Get.to(
                                  () => PhoneNumberView(isGuest: false),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 350),
                                ),
                                child: Text(
                                  "SIGN_UP".tr,
                                  style: TextStyle(
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (authController.loader)
            Positioned.fill(
              child: Container(
                color: Colors.white60,
                child: const Center(child: LoaderCircle()),
              ),
            ),
        ],
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _SocialCircle({this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      radius: 28,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _LoginViewState._accent, width: 1.2),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: _LoginViewState._accent)
            : Text(
                label ?? "",
                style: TextStyle(
                  color: _LoginViewState._accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
      ),
    );
  }
}
