import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:update_product/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartValue;
  final int chatValue;

  const AdminMainAppBar({
    super.key,
    required this.cartValue,
    required this.chatValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _AdminMainAppBarState createState() => _AdminMainAppBarState();
}

class _AdminMainAppBarState extends State<AdminMainAppBar> {
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

  final TextStyle textstyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          Text(
            a_username.toUpperCase(),
            textAlign: TextAlign.center,
            style: textstyle,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  //deleteimage(index);
                  print("123");
                },
                icon: Icon(Icons.logout_sharp),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
