// ignore_for_file: sort_child_properties_last
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../menu/controllers/menu_controller.dart';
import '../../menu/views/menu_view.dart';
import 'home_vew_shimmer.dart';

Widget homeMenuSection() {
  const catBg = Color(0xFFFFF3B0); // soft yellow circle like mock
  return GetBuilder<MenuuController>(
    builder: (menuController) => Column(
      children: [
        // header row (kept)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("OUR_MENU".tr, style: fontBold),
            InkWell(
              onTap: () {
                Get.to(() => MenuView(fromHome: true, categoryId: 0));
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColor.primaryColor.withAlpha(30),
                ),
                child: Text("VIEW_ALL".tr, style: fontRegularBoldwithColor),
              ),
            )
          ],
        ),
        SizedBox(height: 12.h),

        // chips row
        menuController.categoryDataList.isNotEmpty
            ? SizedBox(
          height: 96.h,
          width: double.infinity,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            scrollDirection: Axis.horizontal,
            itemCount: menuController.categoryDataList.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final item = menuController.categoryDataList[index];
              return _CategoryChip(
                label: item.name ?? '',
                imageUrl: item.cover ?? '',
                bgColor: catBg,
                onTap: () {
                  Get.to(() => MenuView(fromHome: true, categoryId: index));
                },
              );
            },
          ),
        )
            : menuSectionShimmer(),
      ],
    ),
  );
}

/// Single category chip: yellow circle with icon + caption
class _CategoryChip extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;
  final Color bgColor;

  const _CategoryChip({
    required this.label,
    required this.imageUrl,
    required this.onTap,
    this.bgColor = const Color(0xFFFFF3B0),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){



      },
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 72.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // circle
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  // Optional tint to get the red line-icon feel (works best with mono/transparent icons)
                  color: const Color(0xFFE84C4C),
                  colorBlendMode: BlendMode.srcIn,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // label
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4C4C4C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
