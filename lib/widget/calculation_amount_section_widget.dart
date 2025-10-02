import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../util/constant.dart';
import '../app/modules/cart/controllers/cart_controller.dart';
import '../app/modules/splash/controllers/splash_controller.dart';

Widget calculationAmountSection(controller) {
  final CartController cartController = Get.find<CartController>();
  final splash = Get.find<SplashController>();
  int digits = 2;
  try {
    digits = int.parse(splash.configData.siteDigitAfterDecimalPoint.toString());
  } catch (_) {}

  String fmt(double value) => value.toStringAsFixed(digits);
  final currencySymbol = 'CURRENCY_SYMBOL'.tr;
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
      side: const BorderSide(color: AppColor.dividerColor),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              Text(
                'SUBTOTAL'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                "$currencySymbol ${fmt(cartController.totalCartValue)}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              Text(
                'DISCOUNT'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                "$currencySymbol ${fmt(cartController.couponDiscount)}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              Text(
                'DELIVERY_CHARGE'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                "$currencySymbol ${fmt(cartController.deliveryCharge)}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Text(
          '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              Text(
                'TOTAL'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                "$currencySymbol ${fmt(cartController.total)}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
