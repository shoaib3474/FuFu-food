// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../helper/device_token.dart';
import '../../../../helper/notification_helper.dart';
import '../../../../util/constant.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/views/cart_view.dart';
import '../../home/views/home_view.dart';
import '../../home/widget/featured_item_section.dart';
import '../../menu/views/menu_view.dart';
import '../../profile/views/profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardView> {
  final box = GetStorage();
  PageController? pageController;
  int pageIndex = 0;
  List<Widget>? screens;
  GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();
  bool canExit = false;
  NotificationHelper notificationHelper = NotificationHelper();
  DeviceToken deviceToken = DeviceToken();

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    screens = [
      HomeView(),
      MenuView(fromHome: false, categoryId: 0),
      CartView(fromNav: true),
      FavoritesScreen(),
      ProfileView(),
    ];
    notificationHelper.notificationPermission();
    if (box.read('isLogedIn')) {
      deviceToken.getDeviceToken();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          if (pageIndex != 0) {
            _setPage(0);
          } else {
            if (canExit) {
              SystemNavigator.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'PRESS_BACK_AGAIN_TO_EXIT'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColor.primaryColor,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.all(10),
                ),
              );
              canExit = true;
              Timer(Duration(seconds: 2), () {
                canExit = false;
              });
            }
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: PageView.builder(
            controller: pageController,
            itemCount: screens!.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: screens![index],
              );
            },
          ),
        ),

        bottomNavigationBar: Container(
          height: 60.h,
          margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: LinearGradient(
              colors: [Colors.deepOrange.shade500, Colors.deepOrange.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.5, 0.5],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navIcon(Icons.home_outlined, 0),
              _navIcon(Icons.restaurant_menu_outlined, 1),
              _cartIcon(2),
              _navIcon(Icons.favorite_border_outlined, 3),
              _navIcon(Icons.person_outline, 4),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Normal Navigation Icon
  Widget _navIcon(IconData icon, int index) {
    bool isSelected = pageIndex == index;
    return GestureDetector(
      onTap: () => _setPage(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(isSelected ? 6 : 0),
        child: Icon(
          icon,
          size: isSelected ? 30.sp : 26.sp,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  /// 🔹 Cart Icon with Badge
  Widget _cartIcon(int index) {
    bool isSelected = pageIndex == index;
    return GestureDetector(
      onTap: () => _setPage(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.all(isSelected ? 6 : 0),
            child: Icon(
              Icons.add_shopping_cart,
              size: isSelected ? 30.sp : 26.sp,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          GetBuilder<CartController>(
            builder: (cartController) {
              int itemCount = cartController.cart.length;
              return itemCount > 0
                  ? Positioned(
                      top: -6.h,
                      right: -6.w,
                      child: AnimatedScale(
                        scale: 1.0,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$itemCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Change Page
  void _setPage(int index) {
    setState(() {
      pageController?.jumpToPage(index);
      pageIndex = index;
    });
  }
}
