import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:update_product/app_color.dart';
import 'package:flutter/services.dart';
import 'package:update_product/admin_login.dart';
import 'package:update_product/sample_header.dart';

String l_status = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.primary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      // home: l_status == "login" ? const PageSwitcher() : WelcomePage(),
      home: SamplePage(),
    );
  }
}
