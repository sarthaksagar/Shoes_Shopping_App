import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footware_page/controller/cart_provider.dart';
import 'package:footware_page/controller/home_controller.dart';
import 'package:footware_page/controller/login_conroller.dart';
import 'package:footware_page/firebase_options.dart';
import 'package:footware_page/pages/home_page.dart';
import 'package:footware_page/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  Get.put(LoginController());
  Get.put(HomeController());

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Footwear Store',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}
