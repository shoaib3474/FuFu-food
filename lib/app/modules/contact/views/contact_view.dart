import 'package:flutter/material.dart';
import 'package:get/get.dart';
// It's a good practice to use url_launcher for opening emails or phone dialers.
// You would need to add `url_launcher` to your pubspec.yaml
// import 'package:url_launcher/url_launcher.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  // Helper method to launch URLs
  // Future<void> _launchUrl(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     Get.snackbar('Error', 'Could not launch $url');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Color(0xFFE65A2A),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We’d love to hear from you!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("support@yourapp.com"),
                onTap: () {
                  // _launchUrl('mailto:support@yourapp.com');
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.phone_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("+92 300 1234567"),
                onTap: () {
                  // _launchUrl('tel:+923001234567');
                },
              ),
              SizedBox(height: 400),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.deepOrangeAccent,
                    ),
                  ),
                  onPressed: () {
                    // _launchUrl('mailto:support@yourapp.com');
                  },
                  child: const Text("Send us an Email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
