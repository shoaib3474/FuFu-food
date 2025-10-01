import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodking/widget/item_card_grid.dart';
import 'package:foodking/widget/menulistcard.dart';
import 'package:get/get.dart';

import '../../../../util/style.dart';
import '../../../../widget/item_card_list.dart';
import '../controllers/home_controller.dart';

Widget popularItemSection() {
  return GetBuilder<HomeController>(
    builder: (homeController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 13.h),
          child: Row(
            children: [
              SizedBox(
                height: 24.h,
                child: Text("MOST_POPULAR_ITEMS".tr, style: fontBold),
              ),
            ],
          ),
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: homeController.popularItemDataList.length > 4
              ? 4
              : homeController.popularItemDataList.length,
          itemBuilder: (BuildContext context, index) {
            return itemCardList(
              homeController.popularItemDataList,
              index,
              context,
            );
          },
        ),
      ],
    ),
  );
}

Widget popularItemSection1() {
  return GetBuilder<HomeController>(
    builder: (homeController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 13.h),
          child: Row(
            children: [
              SizedBox(
                height: 24.h,
                child: Text("BEST_SELLER".tr, style: fontBold),
              ),
            ],
          ),
        ),
        GridView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: homeController.popularItemDataList.length > 4
              ? 4
              : homeController.popularItemDataList.length,
          itemBuilder: (BuildContext context, index) {
            return itemCardGrid(
              homeController.popularItemDataList,
              index,
              context,
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ✅ 2 cards per row
            mainAxisSpacing: 12.h, // vertical space
            crossAxisSpacing: 12.w, // horizontal space
            childAspectRatio: 0.70, // adjust card height/width
          ),
        ),
      ],
    ),
  );
}
