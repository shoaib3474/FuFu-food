import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../controllers/auth_controller.dart';

class SignupView extends StatefulWidget {
  String? phoneNumber;
  SignupView({super.key, this.phoneNumber});
  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode? fName;
  FocusNode? lName;
  FocusNode? email;
  FocusNode? password;

  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    fName = FocusNode();
    lName = FocusNode();
    email = FocusNode();
    password = FocusNode();
  }

  @override
  void dispose() {
    fName!.dispose();
    lName!.dispose();
    email!.dispose();
    password!.dispose();
    super.dispose();
  }

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
                  colorFilter: ColorFilter.mode(
                    Colors.yellow, // Bright yellow for the icon
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Image.asset(
                        Images.logo,
                        height: 60.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'CREATE_ACCOUNT'.tr,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellow, // Yellow text
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FIRST_NAME'.tr,
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TextFormField(
                              autofocus: true,
                              focusNode: fName,
                              onFieldSubmitted: (term) {
                                fName!.unfocus();
                                FocusScope.of(context).requestFocus(lName);
                              },
                              controller: _firstNameController,
                              validator: (value) =>
                              value!.isEmpty ? 'PLEASE_TYPE_FIRST_NAME'.tr : null,
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
                                    color: Colors.yellow, // Yellow focused error border
                                  ),
                                ),
                                fillColor: Colors.grey[800], // Dark background
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: BorderSide(
                                    color: Colors.yellow, // Yellow focused border
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.grey, // Light grey border
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'LAST_NAME'.tr,
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TextFormField(
                              autofocus: true,
                              focusNode: lName,
                              onFieldSubmitted: (term) {
                                lName!.unfocus();
                                FocusScope.of(context).requestFocus(email);
                              },
                              controller: _lastNameController,
                              validator: (value) =>
                              value!.isEmpty ? 'PLEASE_TYPE_LAST_NAME'.tr : null,
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
                                    color: Colors.yellow, // Yellow focused error border
                                  ),
                                ),
                                fillColor: Colors.grey[800], // Dark background
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: BorderSide(
                                    color: Colors.yellow, // Yellow focused border
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.grey, // Light grey border
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'EMAIL'.tr,
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TextFormField(
                              autofocus: true,
                              focusNode: email,
                              onFieldSubmitted: (term) {
                                email!.unfocus();
                                FocusScope.of(context).requestFocus(password);
                              },
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return "ENTER_VALID_EMAIL".tr;
                                } else {
                                  return null;
                                }
                              },
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
                                    color: Colors.yellow, // Yellow focused error border
                                  ),
                                ),
                                fillColor: Colors.grey[800], // Dark background
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: BorderSide(
                                    color: Colors.yellow, // Yellow focused border
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.grey, // Light grey border
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'PASSWORD'.tr,
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TextFormField(
                              obscureText: passwordVisible,
                              autofocus: true,
                              focusNode: password,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                              validator: (value) =>
                              value!.isEmpty ? 'PLEASE_TYPE_PASSWORD'.tr : null,
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
                                    color: Colors.yellow, // Yellow focused error border
                                  ),
                                ),
                                fillColor: Colors.grey[800], // Dark background
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey, // Gray icon for password visibility
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: BorderSide(
                                    color: Colors.yellow, // Yellow focused border
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.grey, // Light grey border
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
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      authController.register(
                                          _firstNameController.text,
                                          _lastNameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          widget.phoneNumber);
                                      validate = true;
                                    } else {
                                      validate = false;
                                    }
                                    (context as Element).markNeedsBuild();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange, // Orange button
                                    minimumSize: Size(320.w, 52.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26.r),
                                    ),
                                  ),
                                  child: Text(
                                    "SIGN_UP".tr,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // White text on button
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          authController.loader
              ? Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.6), // Dimmed loader background
              child: const Center(child: LoaderCircle()),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
