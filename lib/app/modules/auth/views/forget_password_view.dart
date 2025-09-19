import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black, // Dark background color
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.black, // Matching dark background
              leading: IconButton(
                icon: SvgPicture.asset(
                  Images.back,
                  colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn), // Yellow icon for contrast
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Image.asset(
                    Images.logo,
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'FORGOT_PASSWORD'.tr,
                    style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Rubik', // Modern clean font
                        color: Colors.yellow), // Yellow text color for contrast
                  ),
                  SizedBox(height: 41.h),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              'EMAIL'.tr,
                              style: TextStyle(color: Colors.white), // White text for label
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.w, right: 16.w, top: 8.h),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return "Enter valid email";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white), // White text color
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.yellow, // Yellow error border
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.yellow, // Yellow error border
                                  ),
                                ),
                                fillColor: Colors.grey[800], // Dark input field background
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: BorderSide(
                                      color: Colors.yellow, width: 1.w), // Yellow focused border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  borderSide: BorderSide(
                                      width: 1.w, color: Colors.grey), // Gray border
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final FormState? form = _formKey.currentState;
                                  if (form!.validate()) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    authController
                                        .forgetPassword(_emailController.text);
                                    validate = true;
                                  } else {
                                    validate = false;
                                  }
                                  (context as Element).markNeedsBuild();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange, // Orange button color
                                  minimumSize: Size(328.w, 52.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26.r),
                                  ),
                                ),
                                child: Text(
                                  "NEXT".tr,
                                  style: TextStyle(color: Colors.white), // White text on button
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('ALREADY_HAVE_AN_ACCOUNT'.tr,
                                  style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: Colors.white,
                                      fontSize: 12.sp)),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () {
                                  Get.to(() => LoginView());
                                },
                                child: Text(
                                  'LOGIN'.tr,
                                  style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: Colors.yellow, // Yellow login text
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          authController.loader
              ? Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.6), // Dimmed overlay for loader
              child: const Center(
                child: LoaderCircle(),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
