import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & FAQs")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text("How to place an order?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("You can place an order by browsing menu and tapping on 'Add to Cart'."),
            )],
          ),
          ExpansionTile(
            title: Text("What payment methods are supported?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("We support Cash on Delivery, Debit/Credit Cards and Wallets."),
            )],
          ),
          ExpansionTile(
            title: Text("How can I track my order?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Go to Orders tab in Profile section to track live updates."),
            )],
          ),
        ],
      ),
    );
  }
}
