// ignore_for_file: sort_child_properties_last, deprecated_member_use, prefer_interpolation_to_compose_strings
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodking/app/modules/contact/views/contact_view.dart';
import 'package:foodking/app/modules/help/views/help_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../widget/loader.dart';

import '../../auth/views/login_view.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/profile_controller.dart';

// existing routes you already had
import '../../order/views/order_view.dart';
import '../widget/edit_profile_view.dart';
import '../widget/profile_address_view.dart';
import '../widget/change_language_view.dart';
import '../widget/change_password_view.dart';
import '../../dashboard/views/dashboard_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final box = GetStorage();

  // palette to match screenshot
  static const _bg1 = Color(0xFFFFC9AC); // peach
  static const _bg2 = Color(0xFFFF955B); // orange mid
  static const _bg3 = Color(0xFFE65A2A); // deep orange
  static const _sheet = Color(0xFFE65A2A); // sheet color
  static const _white = Colors.white;

  @override
  void initState() {
    super.initState();
    Get.put(SplashController());
    final profileController = Get.put(ProfileController());
    final isLogedIn = box.read('isLogedIn') == true;
    if (isLogedIn) profileController.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final sheetW = width * 0.78; // right-side curved sheet
    bool isLoggedIn = box.read('isLogedIn') == true;

    return GetBuilder<ProfileController>(
      builder: (c) => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // gradient background like the mock
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_bg1, _bg2, _bg3],
                    ),
                  ),
                ),

                // back chevron (top-left)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: _white,
                        size: 28,
                      ),
                      onPressed: Get.back,
                    ),
                  ),
                ),

                // // home bubble (bottom-left)
                // SafeArea(
                //   child: Align(
                //     alignment: Alignment.bottomLeft,
                //     child: Padding(
                //       padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                //       child: InkWell(
                //         borderRadius: BorderRadius.circular(24),
                //         onTap: () => Get.offAll(() => const DashboardView()),
                //         child: Container(
                //           width: 56, height: 56,
                //           decoration: BoxDecoration(
                //             color: _sheet,
                //             borderRadius: BorderRadius.circular(20),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(.15),
                //                 blurRadius: 10,
                //                 offset: const Offset(0, 6),
                //               )
                //             ],
                //           ),
                //           // child: const Icon(Icons.home_rounded, color: _white),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // right-side curved menu sheet
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: isLoggedIn
                        ? Container(
                            width: sheetW,
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.fromLTRB(
                              18.w,
                              18.h,
                              18.w,
                              18.h,
                            ),
                            decoration: BoxDecoration(
                              color: _sheet,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.2),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // avatar + name/email
                                Row(
                                  children: [
                                    _avatar(c),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (box.read('isLogedIn') == true
                                                ? (c.profileData.name ??
                                                      'USER'.tr)
                                                : 'GUEST'.tr),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _white,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            (box.read('isLogedIn') == true
                                                ? (c.profileData.email ??
                                                      'USER_EXAMPLE_EMAIL'.tr)
                                                : 'GUEST_EXAMPLE_EMAIL'.tr),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _white.withOpacity(.85),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                _divider(),

                                // menu items
                                _tile(
                                  icon: Icons.shopping_bag_outlined,
                                  label: 'MY_ORDERS'.tr,
                                  onTap: () => Get.to(
                                    () => const OrderView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),
                                _tile(
                                  icon: Icons.person_outline,
                                  label: 'MY_PROFILE'.tr,
                                  onTap: () => Get.to(
                                    () => EditProfileView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),
                                _tile(
                                  icon: Icons.location_on_outlined,
                                  label: 'DELIVERY_ADDRESS'.tr,
                                  onTap: () => Get.to(
                                    () => const ProfileAddressView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                // _divider(),
                                // _tile(
                                //   icon: Icons.credit_card_outlined,
                                //   label: "Payment Methods",
                                //   onTap: () => Get.snackbar(
                                //     "Payment Methods",
                                //     "Coming soon",
                                //     backgroundColor: Colors.black87,
                                //     colorText: _white,
                                //     snackPosition: SnackPosition.BOTTOM,
                                //   ),
                                // ),
                                _divider(),
                                _tile(
                                  icon: Icons.call_outlined,
                                  label: 'CONTACT_US'.tr,
                                  onTap: () => Get.to(
                                    () => const ContactView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),
                                _tile(
                                  icon: Icons.help_outline,
                                  label: 'HELP_AND_FAQS'.tr,
                                  onTap: () => Get.to(
                                    () => const HelpView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),
                                _tile(
                                  icon: Icons.settings_outlined,
                                  label: 'SETTINGS'.tr,
                                  onTap: () => Get.to(
                                    () => const ChangeLanguageView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),
                                _tile(
                                  icon: Icons.lock_outline,
                                  label: 'CHANGE_PASSWORD'.tr,
                                  onTap: () => Get.to(
                                    () => ChangePasswordView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),

                                // logout
                                _tile(
                                  icon: Icons.logout_rounded,
                                  label: 'LOG_OUT'.tr,
                                  onTap: () {
                                    if (box.read('isLogedIn') == true) {
                                      box.write('isLogedIn', false);
                                      Get.offAll(() => const DashboardView());
                                    } else {
                                      box.write(
                                        'isLogedIn',
                                        false,
                                      ); // ensure guest data is reset
                                      Get.offAll(() => const DashboardView());
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: sheetW,
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              color: _sheet,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section title
                                Text(
                                  'QUICK_ACCESS'.tr,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 14.h),

                                // Contact Us
                                _tile(
                                  icon: Icons.call_outlined,
                                  label: 'CONTACT_US'.tr,
                                  onTap: () => Get.to(
                                    () => const ContactView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),

                                // Help & FAQs
                                _tile(
                                  icon: Icons.help_outline,
                                  label: 'HELP_AND_FAQS'.tr,
                                  onTap: () => Get.to(
                                    () => const HelpView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                _divider(),

                                // Settings
                                _tile(
                                  icon: Icons.settings_outlined,
                                  label: 'SETTINGS'.tr,
                                  onTap: () => Get.to(
                                    () => const ChangeLanguageView(),
                                    transition: Transition.cupertino,
                                  ),
                                ),
                                Spacer(),
                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _bg2,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: () => Get.to(
                                      () => LoginView(),
                                      transition: Transition.cupertino,
                                    ),
                                    child: Text(
                                      'LOGIN_NOW'.tr,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          if (c.loader)
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

  // avatar builder with shimmer while loading
  Widget _avatar(ProfileController c) {
    final isIn = box.read('isLogedIn') == true;
    final url = c.profileData.image;
    if (!isIn || url == null || url.isEmpty) {
      return const CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: _white),
      );
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.white24,
          highlightColor: Colors.white38,
          child: Container(width: 44, height: 44, color: Colors.white30),
        ),
        errorWidget: (_, __, ___) => const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: _white),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Divider(color: _white.withOpacity(.45), thickness: 1, height: 1),
  );

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _white.withOpacity(.8), width: 1.2),
              ),
              child: Icon(icon, color: _white, size: 18),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: _white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
