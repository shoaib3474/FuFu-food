// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              /// Open half screen overlay
              Get.to(
                    () => NotificationsPage(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 400),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Main Content"),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.restaurant_menu,
      "text": "We have added a product you might like."
    },
    {
      "icon": Icons.favorite,
      "text": "One of your favorite is on promotion."
    },
    {
      "icon": Icons.shopping_bag,
      "text": "Your order has been delivered"
    },
    {
      "icon": Icons.delivery_dining,
      "text": "The delivery is on his way"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width * 0.75, // takes 75% width like screenshot
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFFF6433),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Divider(color: Colors.white60),

                /// List
                Expanded(
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.white60, indent: 20, endIndent: 20),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(item["icon"], color: Color(0xFFFF6433)),
                        ),
                        title: Text(
                          item["text"],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onTap: () {
                          Get.to(
                                () => DetailPage(message: item["text"]),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 300),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String message;

  const DetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6433),
        title: Text("Detail"),
      ),
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
