import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
// lib/app/modules/favorites/views/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';
import '../../home/controllers/home_controller.dart';
// import '../controllers/favorites_controller.dart';
import '../../../../widget/item_card_grid.dart';
// import '../../../../widget/favorite_heart_button.dart';
import '../../../../util/style.dart';
import '../../../../widget/item_card_grid.dart';
import '../controllers/home_controller.dart';
// import '../../../../widget/favorite_heart_button.dart';

Widget featureditemSection() {
  return GetBuilder<HomeController>(
    builder: (homeController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
          child: Row(
            children: [
              SizedBox(
                height: 24.h,
                child: Text("FEATURED_ITEMS".tr, style: fontBold),
              ),
              const Spacer(),
              // (Optional) quick nav to Favorites screen
              IconButton(
                onPressed: () => Get.to(() => const FavoritesScreen()),
                icon: const Icon(Icons.favorite),
                tooltip: 'FAVORITES'.tr,
              ),
            ],
          ),
        ),
        MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          itemCount: homeController.featuredItemDataList.length > 4
              ? 4
              : homeController.featuredItemDataList.length,
          itemBuilder: (context, index) {
            final item = homeController.featuredItemDataList[index];
            // Assuming item.id is an int
            final itemId = item.id ?? 0;

            return Stack(
              children: [
                // Your original card
                itemCardGrid(
                  homeController.featuredItemDataList,
                  index,
                  context,
                ),

                // Heart overlay
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteHeartButton(itemId: itemId),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../controllers/home_controller.dart';
// import '../controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Color get _brandYellow => const Color(0xFFF7C64A);
  Color get _accentRed => const Color(0xFFE64A45);

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    final fav = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: _brandYellow,
      appBar: AppBar(
        backgroundColor: _brandYellow,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'FAVORITES'.tr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<FavoritesController>(
        builder: (_) {
          // Build a map of all known items by ID for quick lookup
          final Map<int, dynamic> allById = {};
          void addAll(Iterable<dynamic> list) {
            for (final it in list) {
              final int? id = it.id;
              if (id != null) allById[id] = it;
            }
          }

          addAll(home.itemDataList);
          addAll(home.popularItemDataList);
          addAll(home.featuredItemDataList);

          // Resolve favorites into actual items (ignore IDs not present)
          final favoredItems = fav.favoriteIds
              .where(allById.containsKey)
              .map((id) => allById[id]!)
              .toList();

          // White rounded sheet background
          Widget sheet(Widget child) => Stack(
            children: [
              Positioned.fill(
                top: 12.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: child),
            ],
          );

          if (favoredItems.isEmpty) {
            return sheet(
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    'NO_FAVORITES_YET'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            );
          }

          return sheet(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    "BUY_YOUR_FAVORITE_DISH".tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _accentRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 14.w,
                        // Keeps uniform card size like the screenshot
                        childAspectRatio: 0.78,
                      ),
                      itemCount: favoredItems.length,
                      itemBuilder: (context, index) {
                        final item = favoredItems[index];
                        final itemId = item.id ?? 0;

                        return Stack(
                          children: [
                            // Your existing card widget (no dummy data)
                            // If this naturally sizes itself, the AspectRatio
                            // keeps grids visually consistent.
                            AspectRatio(
                              aspectRatio: 0.78,
                              child: itemCardGrid(favoredItems, index, context),
                            ),
                            // Heart at top-right of each card
                            Positioned(
                              top: 8,
                              right: 8,
                              child: FavoriteHeartButton(itemId: itemId),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
