import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/style.dart';
import '../../../../widget/item_card_list.dart';
import '../../../../widget/item_caution.dart';
import '../../item/views/item_view.dart';
import '../controllers/home_controller.dart';
import '../views/bestseller.dart';

Widget BestItemSection() {
  return GetBuilder<HomeController>(
    builder: (homeController) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Padding(
          padding: EdgeInsets.only(
            top: 10.h,
            bottom: 8.h,
            left: 6.w,
            right: 6.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BEST_SELLER".tr, style: fontBold.copyWith(fontSize: 18.sp)),
              GestureDetector(
                onTap: () {
                  Get.to(BestsellerView());
                  // TODO: Navigate to all items screen
                },
                child: Text(
                  "SEE_ALL".tr,
                  style: fontBold.copyWith(
                    fontSize: 14.sp,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Horizontal Row Builder
        SizedBox(
          height: 130.h, // card height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.popularItemDataList.length > 6
                ? 6
                : homeController.popularItemDataList.length,
            itemBuilder: (BuildContext context, index) {
              var item = homeController.popularItemDataList[index];

              return Container(
                width: 80.w, // each card width
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  image: DecorationImage(
                    image: NetworkImage(item.cover ?? ""), // ✅ your image field
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    /// Price Tag + Caution BottomSheet
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: InkWell(
                        onTap: () async {
                          await Get.find<HomeController>().getItemDetails(
                            itemID: item.id!,
                          );

                          showBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SingleChildScrollView(
                              child: ItemView(itemDetails: item),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.h,
                            horizontal: 8.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "${'CURRENCY_SYMBOL'.tr}${(double.tryParse(item.price ?? '0')?.toInt() ?? 0)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
