// ignore_for_file: must_be_immutable, sort_child_properties_last, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodking/widget/menulistcard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/bottom_cart_widget.dart';
import '../../../../widget/item_card_grid.dart';
import '../../../../widget/item_card_list.dart';
import '../../../../widget/no_items_available.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/views/search_view.dart';
import '../controllers/menu_controller.dart';
import '../widget/menu_view_shimmer.dart';

class MenuView extends StatefulWidget {
  bool? fromHome;
  int? categoryId;

  MenuView({
    super.key,
    this.fromHome,
    this.categoryId,
  });

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final box = GetStorage();
  MenuuController menuController = Get.put(MenuuController());

  @override
  void initState() {
    if (box.read('viewValue') == null) {
      box.write('viewValue', 0);
    }
    if (menuController.categoryDataList.isNotEmpty) {
      menuController.getCategoryWiseItemDataList(
          menuController.categoryDataList[widget.categoryId!].slug!);
      menuController.fromHome = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuuController>(
      builder: (menuController) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: TextField(
              readOnly: true,
              onTap: () {
                Get.to(() => const SearchView());
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 8.h),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Category Chips Section
            menuController.categoryDataList.isNotEmpty
                ? menuSection(widget.fromHome!, widget.categoryId!)
                : menuItemSectionGridShimmer(),
            // Items Section
            Expanded(
              child: menuController.categoryDataList.isNotEmpty
                  ? menuVegNonVegSection(
                  context, box, widget.fromHome!, widget.categoryId!)
                  : Column(
                children: [menuItemSectionGridShimmer()],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
        widget.fromHome! ? const BottomCartWidget() : const SizedBox(),
      ),
    );
  }
}
Widget menuSection(bool fromHome, int categoryId) {
  return GetBuilder<MenuuController>(
    builder: (menuController) => Container(
      color: Colors.deepOrange,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        height: 90.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: menuController.categoryDataList.length,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemBuilder: (context, index) {
            final isSelected = menuController.currentIndex == index;

            return GestureDetector(
              onTap: () {
                menuController.getCategoryWiseItemDataList(
                    menuController.categoryDataList[index].slug!);
                menuController.setCategoryIndex(index);
                menuController.fromHome = false;
                menuController.currentIndex = index;
                (context as Element).markNeedsBuild();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutQuad,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Color(
                      0xFFF3D296),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Category Icon
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: menuController.categoryDataList[index].cover!,
                          height: 30.h,
                          width: 30.w,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.limeAccent!,
                            highlightColor: Colors.deepOrange!,
                            child: Container(
                              height: 30.h,
                              width: 30.w,
                              color: Colors.deepOrange,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.white),
                        ),
                      ],
                    ),
                    // SizedBox(height: 6.h),

                    /// Category Name

                    Text(
                      menuController.categoryDataList[index].name!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.black
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget menuVegNonVegSection(context, box, bool fromHome, int categoryId) {
  return GetBuilder<MenuuController>(
    builder: (menuController) => RefreshIndicator(
      color: AppColor.primaryColor,
      onRefresh: () async {
        menuController.getCategoryWiseItemDataList(
            menuController.categoryDataList[menuController.currentIndex].slug!);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Sorting Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sort by Popular",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.sp)),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          box.write('viewValue', 0);
                          (context as Element).markNeedsBuild();
                        },
                        child: Icon(Icons.view_list,
                            color: box.read('viewValue') == 0
                                ? AppColor.primaryColor
                                : Colors.grey),
                      ),
                      SizedBox(width: 16.w),
                      InkWell(
                        onTap: () {
                          box.write('viewValue', 1);
                          (context as Element).markNeedsBuild();
                        },
                        child: Icon(Icons.grid_view,
                            color: box.read('viewValue') == 1
                                ? AppColor.primaryColor
                                : Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Food Items
            !menuController.iSmenuItemEmpty
                ? Column(
              children: [
                if (box.read('viewValue') == 1) menuItemSectionGrid(),
                if (box.read('viewValue') == 0) menuItemSectionList(),
              ],
            )
                : const NoItemsAvailable()
          ],
        ),
      ),
    ),
  );
}

Widget menuItemSectionGrid() {
  return GetBuilder<MenuuController>(
    builder: (menuController) => !menuController.menuItemLoader
        ? Padding(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      child: Column(
        children: [
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: menuController.categoryItemDataList.length,
            itemBuilder: (context, index) {
              final item = menuController.categoryItemDataList[index];
              final int itemId = (item.id is int)
                  ? item.id as int
                  : int.tryParse('${item.id}') ?? 0;

              return Stack(
                children: [
                  // your original card (with its own add-to-cart logic inside)
                  itemCardGrid(menuController.categoryItemDataList, index, context),

                  // ❤️ Favorite overlay (same as Featured)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteHeartButton(itemId: itemId),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    )
        : menuItemSectionGridShimmer(),
  );
}

Widget menuItemSectionList() {
  return GetBuilder<MenuuController>(
    builder: (menuController) => !menuController.menuItemLoader
        ? Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: menuController.categoryItemDataList.length,
            itemBuilder: (BuildContext context, index) {
              final item = menuController.categoryItemDataList[index];
              final int itemId = (item.id is int)
                  ? item.id as int
                  : int.tryParse('${item.id}') ?? 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // ✅ Your original list card (keeps its ADD logic)
                  itemCardList1(
                    menuController.categoryItemDataList,
                    index,
                    context,
                  ),

                  // ❤️ Favorite overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteHeartButton(itemId: itemId),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    )
        : menuItemSectionListShimmer(),
  );
}
/// Reusable Food Card (MODIFIED)
Widget foodCard(item, {bool isList = false}) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          child: CachedNetworkImage(
            imageUrl: item.cover ?? "",
            height: isList ? 160.h : 140.h,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[200]),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name ?? "",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 4.h),
              Text(item.description ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
              SizedBox(height: 8.h),
              // START: MODIFIED SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("\$${item.price ?? '0.00'}",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor)),
                  GestureDetector(
                    onTap: () {
                      // ADD TO CART LOGIC GOES HERE
                      // Example: Get.find<MenuuController>().addToCart(item);
                      print("Added ${item.name} to cart!");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.red, // Red colored button
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              // END: MODIFIED SECTION
            ],
          ),
        ),
      ],
    ),
  );
}