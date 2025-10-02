// ignore_for_file: sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/no_items_available.dart';
import '../../offer/controllers/offer_controller.dart';
import '../../offer/widget/offer_shimmer.dart';
// import '../controllers/offer_controller.dart';
// import '../widget/offer_shimmer.dart';

class OfferWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const OfferWidget({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferController>(
      init: OfferController(),
      builder: (offerController) {
        if (offerController.lodear) {
          return const OfferShimmer();
        }

        if (offerController.offerDataList.isEmpty) {
          return const NoItemsAvailable();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: fontBoldWithColorBlack),
                  GestureDetector(
                    onTap: onViewAll,
                    child: Row(
                      children: [
                        Text(
                          "VIEW_ALL".tr,
                          style: fontBoldWithColorBlack.copyWith(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColor.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Horizontal List
            SizedBox(
              height: 160.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: offerController!.offerDataList.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final offer = offerController?.offerDataList[index];
                  return InkWell(
                    onTap: () {
                      offerController.getOfferItemList(offer!.slug.toString());
                    },
                    child: Container(
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CachedNetworkImage(
                              imageUrl: offer!.image.toString(),
                              fit: BoxFit.cover,
                              width: 120.w,
                              height: 160.h,
                              placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  width: 120.w,
                                  height: 160.h,
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[400]!,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                "55 "
                                "}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
