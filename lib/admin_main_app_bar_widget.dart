import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:update_product/app_color.dart';

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
  final TextStyle textstyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
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
            "username",
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
