// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodking/app/modules/cart/views/cart_view.dart';
import 'package:foodking/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../../offer/controllers/offer_controller.dart';
import '../../profile/views/notification screen.dart';
import '../../search/views/search_view.dart';
import '../controllers/home_controller.dart';
import '../widget/active_order_status.dart';
import '../widget/bestse.dart';
import '../widget/featured_item_section.dart';
import '../widget/home_menu_section.dart';
import '../widget/home_offer_section.dart';
import '../widget/home_vew_shimmer.dart';
import '../widget/popular_item_section.dart';
import 'offerwidget.dart';

class BestsellerView extends StatefulWidget {
  const BestsellerView({super.key});
  @override
  State<BestsellerView> createState() => _BestsellerView();
}

class _BestsellerView extends State<BestsellerView> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Get.find<HomeController>().getBranchList();
      Get.find<HomeController>().getCategoryList();
      Get.find<HomeController>().getPopularItemDataList();
      Get.find<HomeController>().getFeaturedItemDataList();
      Get.find<OfferController>().getOfferList();

      if (box.read('isLogedIn') == true) {
        Get.find<HomeController>().getActiveOrderList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeController>(
        builder:
            (homeController) => Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: Stack(
                  children: [
                    _Header(),
                Positioned.fill(
                  top: 96.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                    ),



                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with search bar + icons
                          Row(
                            children: [
                              // Search bar
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const SearchView());
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: [
                                        Center(child: Text('its time to buy your fav'))
                                       // .tune, color: Colors.red.shade400, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Action icons

                            ],
                          ),

                        ],
                      ),
                    ),
                )],
                ),
              ),

              body: GetBuilder<HomeController>(
                builder:
                    (homeController) => Stack(
                  children: [
                    Padding(
                      padding:
                      homeController.activeOrderData.isEmpty ||
                          box.read('isLogedIn') == false
                          ? EdgeInsets.only(left: 16.h, right: 16.h)
                          : EdgeInsets.only(
                        left: 16.h,
                        right: 16.h,
                        bottom: 100.h,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            child:
                            homeController.loader
                                ? Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                height: 52.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                    16.r,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            )
                                : SizedBox(
                              // child: TextField(
                              //   showCursor: true,
                              //   readOnly: true,
                              //   onTap: () {
                              //     Get.to(
                              //       () => const SearchView(),
                              //     );
                              //   },
                              //   decoration: InputDecoration(
                              //     contentPadding:
                              //         EdgeInsets.symmetric(
                              //           horizontal: 0.w,
                              //           vertical: 0.h,
                              //         ),
                              //     hintText: "SEARCH".tr,
                              //     hintStyle: const TextStyle(
                              //       color: AppColor.gray,
                              //     ),
                              //     prefixIcon: SizedBox(
                              //       child: Padding(
                              //         padding: EdgeInsets.all(
                              //           12.r,
                              //         ),
                              //         child: SvgPicture.asset(
                              //           Images.iconSearch,
                              //           fit: BoxFit.cover,
                              //           color: AppColor.gray,
                              //           height: 16.h,
                              //           width: 16.w,
                              //         ),
                              //       ),
                              //     ),
                              //     filled: true,
                              //     fillColor: AppColor.itembg,
                              //     focusedBorder:
                              //         OutlineInputBorder(
                              //           borderRadius:
                              //               BorderRadius.all(
                              //                 Radius.circular(
                              //                   12.r,
                              //                 ),
                              //               ),
                              //           borderSide: BorderSide(
                              //             color:
                              //                 AppColor.itembg,
                              //             width: 1.w,
                              //           ),
                              //         ),
                              //     enabledBorder:
                              //         OutlineInputBorder(
                              //           borderRadius:
                              //               BorderRadius.all(
                              //                 Radius.circular(
                              //                   12.r,
                              //                 ),
                              //               ),
                              //           borderSide: BorderSide(
                              //             width: 0.w,
                              //             color:
                              //                 AppColor.itembg,
                              //           ),
                              //         ),
                              //   ),
                              // ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Expanded(
                            child: RefreshIndicator(
                              color: AppColor.primaryColor,
                              onRefresh: () async {
                                homeController.getBranchList();
                                homeController.getCategoryList();
                                homeController
                                    .getFeaturedItemDataList();
                                homeController.getPopularItemDataList();
                                if (box.read('isLogedIn') == true) {
                                  homeController.getActiveOrderList();
                                }
                              },
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                primary: false,
                                scrollDirection: Axis.vertical,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        // homeController.menuLoader ||
                                        //     homeController
                                        //         .categoryDataList
                                        //         .isEmpty
                                        //     ? menuSectionShimmer()
                                        //     : homeMenuSection(),
                                        // //best
                                        // BestItemSection(),
                                        // Get.find<OfferController>()
                                        //     .offerDataList
                                        //     .isEmpty ||
                                        //     Get.find<
                                        //         OfferController
                                        //     >()
                                        //         .lodear
                                        //     ? const SizedBox.shrink()
                                        //     : homeOfferSection(),
                                        //
                                        //


                                        // homeController.featuredLoader ||
                                        //     homeController
                                        //         .featuredItemDataList
                                        //         .isEmpty
                                        //     ? featureditemSectionShimmer()
                                        //     : featureditemSection(),



                                        homeController.popularLoader ||
                                            homeController
                                                .popularItemDataList
                                                .isEmpty
                                            ? popularItemSectionShimmer()
                                            : popularItemSection1(),
                                        // OfferWidget(
                                        //   title: "Best Seller",
                                        //   onViewAll: () {
                                        //     Get.toNamed("/all-offers");
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (homeController.activeOrderData.isNotEmpty &&
                        box.read('isLogedIn') == true)
                      const ActiveOrderStatus(),
                  ],
                ),
              ),
            ),
            Get.find<OfferController>().offerItemlodear
                ? Positioned(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white60,
                child: const Center(child: LoaderCircle()),
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD56B), Color(0xFFFFC043)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(24.r),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18.sp),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Best Seller",
                    style: fontBold.copyWith(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 30.w),
            ],
          ),
        ),
      ),
    );
  }
}