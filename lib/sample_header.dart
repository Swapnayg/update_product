import 'package:flutter/material.dart';
import 'package:update_product/app_color.dart';
import 'package:update_product/admin_main_app_bar_widget.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    return Title(
        color: Colors.blue, // This is required
        title: 'Sample Page',
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
