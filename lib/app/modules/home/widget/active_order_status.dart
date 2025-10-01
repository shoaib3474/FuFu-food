// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:foodking/app/modules/order/views/order_details.dart';

import '../../../../util/constant.dart';
import '../controllers/home_controller.dart';
import '../../order/controllers/order_controller.dart';

class ActiveOrderStatus extends StatefulWidget {
  const ActiveOrderStatus({super.key});

  @override
  State<ActiveOrderStatus> createState() => _ActiveOrderStatusState();
}

class _ActiveOrderStatusState extends State<ActiveOrderStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    Get.put(OrderController());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.blueAccent;
      case 4:
        return Colors.deepPurpleAccent;
      case 7:
        return Colors.orangeAccent;
      case 10:
        return Colors.greenAccent.shade400;
      default:
        return AppColor.primaryColor;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return "YOUR_ORDER_IS_PLACED".tr;
      case 4:
        return "YOUR_ORDER_IS_ACCEPTED".tr;
      case 7:
        return "THE_CHEF_IS_PREPARING_YOUR_FOOD".tr;
      case 10:
        return "THE_DELIVERY_MAN_IS_ON_THE_WAY".tr;
      default:
        return "PREPARING".tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        if (homeController.activeOrderData.isEmpty) {
          return const SizedBox();
        }

        final order = homeController.activeOrderData[0];
        final statusColor = _getStatusColor(order.status ?? 0);

        return Positioned(
          bottom: 0,
          child: SlideTransition(
            position: _offsetAnimation,
            child: InkWell(
              onTap: () async {
                final result = await Get.find<OrderController>()
                    .getOrderDetails(order.id!);

                if (result != null) {
                  Get.to(() => OrderDetailsView(orderId: order.id!));
                }
              },
              child: Container(
                width: Get.width,
                height: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.85),
                      statusColor.withOpacity(0.65),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6.r),
                                  child: SvgPicture.asset(
                                    Images.iconRouting,
                                    colorFilter: ColorFilter.mode(
                                      statusColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getStatusText(order.status ?? 0),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "IT_WILL_TAKE_LESS_THAN".tr +
                                        " ${order.preparationTime} " +
                                        "MINUTES_TO_GET_YOUR_FOOD".tr,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 11.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Arrow Icon
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4.r),
                              child: SvgPicture.asset(
                                Images.round_arrow,
                                colorFilter: ColorFilter.mode(
                                  statusColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      /// Timeline Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: LinearProgressIndicator(
                          minHeight: 6.h,
                          value: (order.status ?? 0) / 10, // scale to max
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
