import 'package:flutter/material.dart';
import 'package:update_product/app_color.dart';
import 'package:update_product/admin_main_app_bar_widget.dart';
import 'package:update_product/Add_product.dart';
import 'package:http/http.dart' as http;
import 'package:update_product/product.dart';
import 'dart:convert';

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
  final List<Product> productData = [];

  @override
  initState() {
    getProductsJson();
  }

  Future<void> getProductsJson() async {
    var response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbz4VKVP6XkHw_jdCkZtFGIMwNqtIZkfwB_CQO4-VXrYtJMgYunE24aaDqglVVA74jxL/exec"));

    dynamic jsonAppData = jsonDecode(response.body);
    dynamic productData1 = jsonDecode(jsonAppData[0]["category"]);
    setState(() {
      for (var i = 0; i < productData1.length; i++) {
        Product proData = Product(
          id: productData1[i]['p_id'],
          name: productData1[i]['p_name'],
          price: productData1[i]['p_price'],
          quantity: productData1[i]['p_qnty'],
          p_category: productData1[i]['p_category'],
          p_brand: productData1[i]['p_brand'],
          storeName: productData1[i]['p_company'],
          description: productData1[i]['p_descption'],
          rating: 0,
          image: [],
          colors: [],
          sizes: [],
          reviews: [],
        );
        productData.add(proData);
      }
      print(productData);
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
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'MY PRODUCTS',
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.5),
                                  letterSpacing: 6 / 100,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            )),
                        Spacer(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColor.secondary),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: const Text('Add Product'),
                          onPressed: () {
                            print("123");
                          },
                        )),
                  ),
                ],
              ),
              DataTable(columns: [
                DataColumn(
                  label: Text('NAme'),
                ),
                DataColumn(
                  label: Text('Price'),
                ),
                DataColumn(
                  label: Text('Quantity'),
                ),
                DataColumn(
                  label: Text('Category'),
                ),
                DataColumn(
                  label: Text('Brand'),
                ),
              ], rows: [
                DataRow(cells: [])
              ])
            ],
          ),
        ));
  }
}
