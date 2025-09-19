// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../app/modules/home/controllers/home_controller.dart';
import 'item_caution.dart';
import '../app/modules/item/views/item_view.dart';
import '../util/constant.dart';
import '../util/style.dart';

// ❤ make sure this path matches your project structure.
// If favorite_heart_button.dart lives in the same /widget folder, this is correct.
// import 'favorite_heart_button.dart';

Widget itemCardList1(dynamic item, int index, BuildContext context) {
  final data = item[index];
  final String imageUrl = data.cover ?? '';
  final String name = data.name ?? '';
  final String desc = (data.description ?? '').toString();
  final String basePrice = data.currencyPrice ?? '';
  final bool hasOffer =
  (data.offer != null && data.offer is List && (data.offer as List).isNotEmpty);
  final String finalPrice =
  hasOffer ? (data.offer[0].currencyPrice ?? basePrice) : basePrice;

  // Try to read a rating if present (fallback: null → hide)
  final double? rating = _extractRating(data);

  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.itembg),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rounded corners + favorite overlay
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    // Image tap behaves like ADD → open Item bottom sheet
                    await Get.find<HomeController>()
                        .getItemDetails(itemID: data.id!);
                    showBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                        child: ItemView(itemDetails: data, indexNumber: index),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[400]!,
                          child: Container(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),

                // ❤ favorite button top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteHeartButton(itemId: data.id ?? 0),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Title • rating —— price
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: name + (• + rating chip if available)
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: fontRegularBold.copyWith(fontSize: 16.sp),
                        ),
                      ),
                      if (rating != null) ...[
                        SizedBox(width: 6.w),
                        Text('•', style: TextStyle(color: Colors.black54)),
                        SizedBox(width: 6.w),
                        _RatingChip(rating: rating),
                      ],
                    ],
                  ),
                ),

                // Right: price (offer-aware)
                Text(
                  finalPrice,
                  style: fontMediumProWithCurrency.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // Description (2 lines)
            Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.45,
                color: AppColor.gray,
              ),
            ),

            SizedBox(height: 10.h),

            // Bottom row: details icon + ADD (kept) + item caution trigger
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Caution / details icon (as you had)
                InkWell(
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                        child: ItemCaution(
                          itemName: data.name,
                          itemCaution: data.caution,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.itembg,
                          offset: Offset(0, 2),
                          blurRadius: 4.r,
                          spreadRadius: .5.r,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14.w,
                          height: 14.h,
                          child: SvgPicture.asset(
                            Images.iconDetails,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Details",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                            color: AppColor.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ADD → same action as tapping the image (open ItemView)
                InkWell(
                  onTap: () async {
                    await Get.find<HomeController>()
                        .getItemDetails(itemID: data.id!);
                    showBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                        child: ItemView(itemDetails: data, indexNumber: index),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.itembg,
                          offset: Offset(0, 4),
                          blurRadius: 5.r,
                          spreadRadius: 1.r,
                        ),
                        BoxShadow(
                          color: AppColor.itembg,
                          offset: Offset(1, 0),
                          blurRadius: 1.r,
                          spreadRadius: 0.r,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14.w,
                          height: 14.h,
                          child: SvgPicture.asset(
                            Images.iconCart,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              AppColor.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "ADD".tr,
                          style: fontRegularBoldwithColor.copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _RatingChip extends StatelessWidget {
  final double rating;
  const _RatingChip({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9DE), // soft orange background
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFE67339)),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              color: const Color(0xFFE67339),
            ),
          ),
        ],
      ),
    );
  }
}

double? _extractRating(dynamic d) {
  try {
    // Try common rating keys safely
    final candidates = [
      d.rating,
      d.avgRating,
      d.rateAvg,
      d.averageRating,
      d.avg_review,
      d.avgReview,
    ];
    for (final v in candidates) {
      if (v == null) continue;
      final parsed = double.tryParse('$v');
      if (parsed != null && parsed > 0) return parsed;
    }
  } catch (_) {}
  return null; // hide chip if absent
}


Widget itemGridList3(List<dynamic> items, BuildContext context) {
  return GridView.builder(
    padding: EdgeInsets.all(12.w),
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,              // ✅ 2 cards per row
      mainAxisSpacing: 12.h,          // vertical space
      crossAxisSpacing: 12.w,         // horizontal space
      childAspectRatio: 0.70,         // adjust card height/width
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return itemCardList1(items, index, context); // ✅ reuse your card
    },
  );
}
