// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:country_picker/country_picker.dart';

import '../../../../util/constant.dart';
import '../../../../widget/loader.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class PhoneNumberView extends StatefulWidget {
  final bool? isGuest;
  const PhoneNumberView({super.key, this.isGuest});

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final box = GetStorage();
  bool validate = false;

  @override
  void initState() {
    super.initState();
    // Set default Pakistan if not stored
    box.writeIfNull('countryFlag', '🇵🇰');
    box.writeIfNull('countryCode', '+92');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: SvgPicture.asset(
                  Images.back,
                  colorFilter: const ColorFilter.mode(
                    Colors.yellow,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => Get.back(),
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
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w600,
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(height: 41.h),

                    /// Mobile Number Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOBILE_NUMBER'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// Country Picker + Phone Input
                        SizedBox(
                          height: 56.h,
                          child: Row(
                            children: [
                              /// Country Picker Dropdown
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      box.write('countryFlag', country.flagEmoji);
                                      box.write('countryCode', "+${country.phoneCode}");
                                      setState(() {});
                                    },
                                  );
                                },
                                child: Container(
                                  width: 100.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        box.read('countryFlag') ?? '🌍',
                                        style: TextStyle(fontSize: 20.sp),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        box.read('countryCode') ?? '+00',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down, color: Colors.white70),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(width: 8.w),

                              /// Phone Number Input
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        value!.isEmpty ? 'Please type Mobile Number' : null,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[800],
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: BorderSide(color: Colors.grey, width: 1.w),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: BorderSide(color: Colors.yellow, width: 1.w),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: BorderSide(color: Colors.yellow, width: 1.w),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: BorderSide(color: Colors.yellow, width: 1.w),
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

                    /// Continue Button
                    ElevatedButton(
                      onPressed: () {
                        final FormState? form = _formKey.currentState;
                        if (form!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (widget.isGuest!) {
                            authController.guestPhoneNumberSignUp(_phoneController.text);
                          } else {
                            authController.phoneNumberSignUp(_phoneController.text);
                          }
                          validate = true;
                        } else {
                          validate = false;
                        }
                        (context as Element).markNeedsBuild();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(328.w, 52.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text("CONTINUE".tr, style: const TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 24.h),

                    /// Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ALREADY_HAVE_AN_ACCOUNT'.tr,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: () => Get.to(() =>  LoginView()),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Loader
          authController.loader
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(child: LoaderCircle()),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
