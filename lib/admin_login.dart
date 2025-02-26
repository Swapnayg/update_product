import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:update_product/app_color.dart';
import 'package:update_product/all_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _al_username = TextEditingController();
  final _al_password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _al_username.dispose();
    _al_password.dispose();
  }

  String al_error_lbl = "";
  bool _apassVisibility = true;

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
                controller: _al_username,
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
                controller: _al_password,
                autofocus: false,
                obscureText: _apassVisibility,
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
                    icon: _apassVisibility
                        ? SvgPicture.asset('assets/icons/Hide.svg',
                            color: AppColor.primary)
                        : SvgPicture.asset('assets/icons/Show.svg',
                            color: AppColor.primary),
                    onPressed: () {
                      _apassVisibility = !_apassVisibility;
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
                  children: <TextSpan>[TextSpan(text: al_error_lbl)],
                ),
              ),

              // Sign In button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
                onPressed: () async {
                  al_error_lbl = '';
                  if (_al_username.text.isNotEmpty &&
                      _al_password.text.isNotEmpty) {
                    await _adminlogin_fun().then((value) {
                      var val = value;
                      if (val == "sucess") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const All_ProductPage()));
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {
                          al_error_lbl = "Please contact support.";
                        });
                      }
                    });
                  } else {
                    _showAlert(context, "Username and password is required.");
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }

  Future<String> _adminlogin_fun() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    var data = {
      "call": "login",
      "l_name": _al_username.text.trim(),
      "l_password": _al_password.text.trim(),
    };
    var result = '';
    await http
        .post(
            Uri.parse(
                "https://script.google.com/macros/s/AKfycbwkmTCZqEbhk_GB2yUa5clPPnXDG0zP7OEU3jtVRGBaFELX9B6q1X-EL6PScGbQbOpd/exec"),
            body: (data))
        .then((response) async {
      if (jsonDecode(response.body)['status'] == "Error") {
        result = "failed";
      } else {
        SharedPreferences? prefs = await SharedPreferences.getInstance();
        prefs.setString("isLoggedIn", "login");
        prefs.setString("a_username", _al_username.text.trim().toString());
        result = "sucess";
      }
    });
    return result;
  }
}

void _showAlert(BuildContext context, text) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Error:",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'poppins'),
            ),
            content: Text(text),
          ));
}
