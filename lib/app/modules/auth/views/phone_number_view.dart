import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class PhoneNumberView extends StatefulWidget {
  bool? isGuest;
  PhoneNumberView({super.key, this.isGuest});

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return GetBuilder<AuthController>(
      builder: (authController) => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black, // Dark background color
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.black, // Dark background
              leading: IconButton(
                icon: SvgPicture.asset(
                  Images.back,
                  colorFilter: ColorFilter.mode(
                    Colors.yellow, // Bright yellow color for icons
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Image.asset(
                      Images.logo,
                      height: 60.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      widget.isGuest!
                          ? 'GUEST_LOGIN'.tr
                          : 'LETS_GET_STARTED'.tr,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontFamily: 'Rubik', // Modern clean font
                        fontWeight: FontWeight.w600,
                        color: Colors.yellow, // Yellow text
                      ),
                    ),
                    SizedBox(height: 41.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // ignore: avoid_print
                            print(box.read('countryFlag').toString());
                          },
                          child: Text(
                            'MOBILE_NUMBER'.tr,
                            style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 14.sp),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 56.h,
                          child: Row(
                            children: [
                              Container(
                                width: 100.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.grey, // Light gray border
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      box.read('countryFlag').toString(),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      box.read('countryCode').toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Please type Mobile Number'
                                        : null,
                                    style: TextStyle(
                                      color: Colors.white, // White text color
                                    ),
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
                                          color: Colors.grey, // Gray border
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final FormState? form = _formKey.currentState;
                            if (form!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (widget.isGuest!) {
                                authController.guestPhoneNumberSignUp(
                                  _phoneController.text,
                                );
                              } else {
                                authController.phoneNumberSignUp(
                                  _phoneController.text,
                                );
                              }
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
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text("CONTINUE".tr, style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ALREADY_HAVE_AN_ACCOUNT'.tr,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                color: Colors.white, // White text for the label
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            InkWell(
                              onTap: () {
                                Get.to(() => LoginView());
                              },
                              child: Text(
                                'LOGIN'.tr,
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  color: Colors.yellow, // Yellow login text
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          authController.loader
              ? Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.6), // Dimmed overlay for loader
              child: const Center(child: LoaderCircle()),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
