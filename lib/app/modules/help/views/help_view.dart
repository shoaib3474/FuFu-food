import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HELP_AND_FAQS".tr),
        backgroundColor: const Color(0xFFE65A2A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: Text("HOW_TO_PLACE_ORDER".tr),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("HOW_TO_PLACE_ORDER_DESC".tr),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("WHAT_PAYMENT_METHODS".tr),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("WHAT_PAYMENT_METHODS_DESC".tr),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("HOW_TRACK_ORDER".tr),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("HOW_TRACK_ORDER_DESC".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
