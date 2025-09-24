// ignore_for_file: unused_local_variable
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/model/body/notification_body.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';
import 'helper/notification_helper.dart';
import 'translation/language.dart';
import 'package:hive_flutter/hive_flutter.dart';

// lib/app/modules/favorites/controllers/favorites_controller.dart
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final box = GetStorage();
dynamic langValue = const Locale('en', null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await Hive.initFlutter();
  // We store only item IDs, so no adapters needed.
  await Hive.openBox<int>('favorite_ids');

  // Put FavoritesController globally
  Get.put(FavoritesController(), permanent: true);

  NotificationBody? body;
  try {
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  } catch (e) {
    debugPrint(e.toString());
  }

  if (box.read('languageCode') != null) {
    langValue = Locale(box.read('languageCode'), null);
  } else {
    langValue = const Locale('it', null);
  }
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: ((context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PS CAFE DO",
        translations: Languages(),
        theme: ThemeData(useMaterial3: false),
        locale: langValue,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: SplashBinding(),
      )),
    ),
  );
}

class FavoritesController extends GetxController {
  late Box<int> _box;
  final RxSet<int> favoriteIds = <int>{}.obs;

  @override
  void onInit() {
    _box = Hive.box<int>('favorite_ids');
    // Load any saved IDs
    favoriteIds.addAll(_box.values);
    super.onInit();
  }

  bool isFavorite(int id) => favoriteIds.contains(id);

  void toggle(int id) {
    if (favoriteIds.contains(id)) {
      // Remove: find all keys that store this value (IDs are added with auto keys)
      final keys = _box.keys.where((k) => _box.get(k) == id).toList();
      _box.deleteAll(keys);
      favoriteIds.remove(id);
    } else {
      _box.add(id);
      favoriteIds.add(id);
    }
    update();
  }

  void remove(int id) => toggle(id);
}
