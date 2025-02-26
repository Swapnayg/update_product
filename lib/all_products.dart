import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:update_product/app_color.dart';
import 'package:update_product/admin_main_app_bar_widget.dart';

class All_ProductPage extends StatefulWidget {
  const All_ProductPage({super.key});

  @override
  _All_ProductPageState createState() => _All_ProductPageState();
}

class _All_ProductPageState extends State<All_ProductPage> {
  @override
  void dispose() {
    super.dispose();
  }

  String l_error_lbl = "";
  String l_lbl_sucess = "";
  String a_username = "";

  @override
  initState() {
    sharedPref();
  }

  Future<void> sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      a_username = prefs.getString('a_username').toString();
    });
  }

  //al_username = prefs1.getString('isLoggedIn').toString();

  @override
  Widget build(BuildContext context) {
    return Title(
        color: Colors.blue, // This is required
        title: 'My Products',
        child: Scaffold(
          appBar: const AdminMainAppBar(
            cartValue: 2,
            chatValue: 2,
          ),
          body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 2 - Status ( LIST )
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'ORDERS STATUS',
                        style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.5),
                            letterSpacing: 6 / 100,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
