import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:update_product/app_color.dart';
import 'package:update_product/all_products.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _l_username = TextEditingController();
  final _l_password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _l_username.dispose();
    _l_password.dispose();
  }

  String l_error_lbl = "";
  String l_lbl_sucess = "";
  bool _passVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('WWelcome to Admin View',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 48,
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColor.secondary.withOpacity(0.1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 2 - Form
              // Email
              TextField(
                controller: _l_username,
                autofocus: false,
                onChanged: (text) {},
                decoration: InputDecoration(
                  hintText: '',
                  labelText: 'Please enter username !',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Message.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              // Password
              TextField(
                controller: _l_password,
                autofocus: false,
                obscureText: _passVisibility,
                decoration: InputDecoration(
                  hintText: '**********',
                  labelText: 'Please enter password!',

                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Lock.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                  //
                  suffixIcon: IconButton(
                    icon: _passVisibility
                        ? SvgPicture.asset('assets/icons/Hide.svg',
                            color: AppColor.primary)
                        : SvgPicture.asset('assets/icons/Show.svg',
                            color: AppColor.primary),
                    onPressed: () {
                      _passVisibility = !_passVisibility;
                      setState(() {});
                    },
                  ),
                ),
              ),
              // Forgot Passowrd

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.red,
                  ),
                  children: <TextSpan>[TextSpan(text: l_error_lbl)],
                ),
              ),

              // Sign In button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_l_username.text.isNotEmpty &&
                        _l_password.text.isNotEmpty) {
                      _adminlogin_fun().then((value) {
                        var val = value;
                        Timer(const Duration(seconds: 1), () {
                          if (val == "sucess") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const All_ProductPage()));
                          } else {
                            setState(() {
                              l_error_lbl = "Please contact support.";
                            });
                          }
                        });
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }

  Future<String> _adminlogin_fun() async {
    var data = {
      "call": "login",
      "l_name": _l_username.text,
      "l_password": _l_password.text,
    };
    var result = '';
    await http
        .post(
            Uri.parse(
                "https://script.google.com/macros/s/AKfycbwkmTCZqEbhk_GB2yUa5clPPnXDG0zP7OEU3jtVRGBaFELX9B6q1X-EL6PScGbQbOpd/exec"),
            body: (data))
        .then((response) async {
      if (response.statusCode == 302) {
        result = "failed";
      } else {
        result = "sucess";
      }
    });
    return result;
  }
}
