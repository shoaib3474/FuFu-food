// ignore_for_file: sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../offer/controllers/offer_controller.dart';

Widget homeOfferSection() {
  return GetBuilder<OfferController>(
    builder: (offerController) {
      return Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: CarouselSlider.builder(
          itemCount: offerController.offerDataList.length,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 6,
          ),
          itemBuilder: (context, index, realIndex) {
            final offer = offerController.offerDataList[index];
            return InkWell(
              onTap: () {
                offerController.getOfferItemList(offer.slug.toString());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    // Left Side: Text offer
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            bottomLeft: Radius.circular(16.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'OFFER_EXPERIENCE_DESC'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'OFFER_DISCOUNT'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Side: Image
                    // Right Side: Image
                    Expanded(
                      flex: 6,
                      child: Container(
                        // Force the image to take the full height of the parent Row
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: offer.image.toString(),
                            fit:
                                BoxFit.fill, // Fill while keeping aspect ratio
                            placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(color: Colors.grey),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[400]!,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// // ignore_for_file: sort_child_properties_last
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../offer/controllers/offer_controller.dart';
//
// Widget homeOfferSection() {
//   return GetBuilder<OfferController>(
//     builder: (offerController) => Padding(
//         padding: EdgeInsets.only(top: 20.h),
//         child: ListView.builder(
//             primary: false,
//             shrinkWrap: true,
//             itemCount: Get.find<OfferController>().offerDataList.length,
//             itemBuilder: (BuildContext context, index) {
//               return InkWell(
//                 onTap: () {
//                   offerController.getOfferItemList(
//                       offerController.offerDataList[index].slug.toString());
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 10.h),
//                   child: Container(
//                     height: 84.h,
//                     width: 328.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.r),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16.r),
//                       child: Hero(
//                         tag: "home-offer-banner-$index",
//                         child: CachedNetworkImage(
//                           imageUrl: offerController.offerDataList[index].image
//                               .toString(),
//                           imageBuilder: (context, imageProvider) => Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           placeholder: (context, url) => Shimmer.fromColors(
//                             child: Container(
//                                 height: 60.h, width: 60.w, color: Colors.grey),
//                             baseColor: Colors.grey[300]!,
//                             highlightColor: Colors.grey[400]!,
//                           ),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             })),
//   );
// }
