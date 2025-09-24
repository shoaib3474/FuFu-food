import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("We’d love to hear from you!", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("📧 support@yourapp.com"),
            const SizedBox(height: 10),
            const Text("📞 +92 300 1234567"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add email launcher here
              },
              child: const Text("Send us an Email"),
            ),
          ],
        ),
      ),
    );
  }
}
