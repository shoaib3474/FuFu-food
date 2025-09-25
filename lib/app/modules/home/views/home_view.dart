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
import '../../cart/controllers/cart_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        builder: (homeController) => Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD600), // bright yellow
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.tune,
                                      color: Colors.red.shade400,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Action icons
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => CartView(fromNav: false),
                                    transition: Transition.cupertino,
                                  );
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    GetBuilder<CartController>(
                                      builder: (cartController) {
                                        int itemCount =
                                            cartController.cart.length;
                                        if (itemCount == 0)
                                          return const SizedBox.shrink();

                                        return Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$itemCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => NotificationsPage(),
                                      transition: Transition
                                          .rightToLeft, // you can also use leftToRight
                                      duration: Duration(milliseconds: 300),
                                    );
                                  },
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => ProfileView(),
                                    transition: Transition.topLevel,
                                  );
                                },

                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Greeting texts
                      const Text(
                        "Good Morning",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Rise And Shine! It’s Breakfast Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              body: GetBuilder<HomeController>(
                builder: (homeController) => Stack(
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
                            child: homeController.loader
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
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
                                homeController.getFeaturedItemDataList();
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
                                        homeController.menuLoader ||
                                                homeController
                                                    .categoryDataList
                                                    .isEmpty
                                            ? menuSectionShimmer()
                                            : homeMenuSection(),
                                        //best
                                        BestItemSection(),
                                        Get.find<OfferController>()
                                                    .offerDataList
                                                    .isEmpty ||
                                                Get.find<OfferController>()
                                                    .lodear
                                            ? const SizedBox.shrink()
                                            : homeOfferSection(),

                                        homeController.featuredLoader ||
                                                homeController
                                                    .featuredItemDataList
                                                    .isEmpty
                                            ? featureditemSectionShimmer()
                                            : featureditemSection(),

                                        homeController.popularLoader ||
                                                homeController
                                                    .popularItemDataList
                                                    .isEmpty
                                            ? popularItemSectionShimmer()
                                            : popularItemSection(),
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
