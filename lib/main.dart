import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:collection';
import 'package:update_product/app_color.dart';
import 'package:update_product/category.dart';
import 'package:update_product/colorway.dart';
import 'package:update_product/brand.dart';
import 'package:update_product/size.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Product',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Add Product'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final List<Category_P> categoryData = [];
final List<Brand_p> brandData = [];
final List<Size_P> sizeData = [];
final List<Colorway> colorData = [];

List<File> selectedImages = [];
final picker = ImagePicker();

int dropdownvalue = 0;

int brandValue = 0;

int? _currentSelectedIndex;
HashSet selectItems = HashSet();
HashSet selectSizeItems = HashSet();
bool isMultiSelectionEnabled = false;
bool isSizeMultiEnabled = false;

var items = [
  'Item 1',
  'Item 2',
  'Item 3',
  'Item 4',
  'Item 5',
];

var brands = [
  'brand 1',
  'brand 2',
  'brand 3',
  'brand 4',
  'brand 5',
];
var arry_sizes = [];
var arry_colors = [];

class _MyHomePageState extends State<MyHomePage> {
  initState() {
    readJson();
  }

  final TextStyle textstyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final InputDecoration decoration = InputDecoration(
    border: OutlineInputBorder(),
  );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int sizeIndex = 0;
    int selSizeIndex = 0;
    Color color = Colors.blue;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                        title: Text('Product Name'),
                        subtitle: SizedBox(
                            width: MediaQuery.of(context).size.width * .71,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: '',
                              ),
                            ))),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Select Category:'),
                        subtitle: SizedBox(
                          width: MediaQuery.of(context).size.width * .71,
                          child: DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: categoryData
                                  .asMap()
                                  .keys
                                  .toList()
                                  .map((index) {
                                return DropdownMenuItem(
                                  child:
                                      Text(categoryData[index].name.toString()),
                                  value: index,
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              }),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Select Brand:'),
                        subtitle: SizedBox(
                          width: MediaQuery.of(context).size.width * .71,
                          child: DropdownButton(
                              value: brandValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items:
                                  brandData.asMap().keys.toList().map((index) {
                                return DropdownMenuItem(
                                  child: Text(brandData[index].name.toString()),
                                  value: index,
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  brandValue = newValue!;
                                });
                              }),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Select Colors:'),
                        subtitle: SizedBox(
                          width: MediaQuery.of(context).size.width * .71,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              GridView.count(
                                shrinkWrap: true,
                                primary: true,
                                padding: const EdgeInsets.all(20.0),
                                crossAxisCount: 15,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 1,
                                children: [
                                  for (int j = 0;
                                      j < colorData.length;
                                      j++) ...[
                                    GridTile(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            colorData[j].selected = !bool.parse(
                                                colorData[j]
                                                    .selected
                                                    .toString());

                                            isMultiSelectionEnabled = true;
                                            doMultiSelection(j);
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            colorData[j].selected = !bool.parse(
                                                colorData[j]
                                                    .selected
                                                    .toString());

                                            isMultiSelectionEnabled = true;
                                            doMultiSelection(j);
                                          });
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: colorData[j].color),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "${colorData[j].name}" +
                                                          " " +
                                                          "${colorData[j].color_code}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 6.0,
                                                          color: colorData[j]
                                                                      .name
                                                                      .toString() ==
                                                                  "Black"
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                    visible: bool.parse(
                                                        colorData[j]
                                                            .selected
                                                            .toString()),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    )),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Select Sizes:'),
                        subtitle: SizedBox(
                          width: MediaQuery.of(context).size.width * .71,
                          child: GridView.count(
                            crossAxisCount: 10,
                            childAspectRatio: (itemWidth / itemHeight),
                            controller:
                                ScrollController(keepScrollOffset: false),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              for (int i = 0; i < sizeData.length; i++) ...[
                                GridTile(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            sizeData[i].selected = !bool.parse(
                                                sizeData[i]
                                                    .selected
                                                    .toString());
                                            isSizeMultiEnabled = true;
                                            doSizeMultiSelection(i);
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            sizeData[i].selected = !bool.parse(
                                                sizeData[i]
                                                    .selected
                                                    .toString());
                                            isSizeMultiEnabled = true;
                                            doSizeMultiSelection(i);
                                          });
                                        },
                                        child: Stack(children: [
                                          MouseRegion(
                                              onHover: _updateLocation,
                                              child: CircleAvatar(
                                                  backgroundColor: bool.parse(
                                                          sizeData[i]
                                                              .selected
                                                              .toString())
                                                      ? AppColor.secondary
                                                      : Colors.grey,
                                                  radius: 20,
                                                  child: Text(
                                                    sizeData[i]
                                                        .number
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                        ]))),
                              ],
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColor.secondary),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: const Text('Select Images'),
                          onPressed: () {
                            getImages();
                          },
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            width: 300.0,
                            height: 200.0,
                            child: selectedImages.isEmpty
                                ? const Center(
                                    child: Text('Sorry nothing selected!!'))
                                : GridView.builder(
                                    itemCount: selectedImages.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Center(
                                          child: kIsWeb
                                              ? Image.network(
                                                  selectedImages[index].path)
                                              : Image.file(
                                                  selectedImages[index]));
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      color: AppColor.secondary,
                      minWidth: 160,
                      onPressed: () {},
                      child: Text(
                        'Add Product',
                        style: textstyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> readJson() async {
    var response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbz4VKVP6XkHw_jdCkZtFGIMwNqtIZkfwB_CQO4-VXrYtJMgYunE24aaDqglVVA74jxL/exec"));

    dynamic jsonAppData = jsonDecode(response.body);
    dynamic cateData1 = jsonDecode(jsonAppData[0]["category"]);
    dynamic brandData1 = jsonDecode(jsonAppData[0]["brand"]);
    dynamic sizeData1 = jsonDecode(jsonAppData[0]["size"]);
    dynamic colorData1 = jsonDecode(jsonAppData[0]["color"]);
    setState(() {
      for (var i = 0; i < cateData1.length; i++) {
        Category_P catData = Category_P(
          name: cateData1[i]['name'],
          iconUrl: cateData1[i]['icon_url'],
          featured:
              bool.parse(cateData1[i]['featured'].toString().toLowerCase()),
        );

        categoryData.add(catData);
      }
      for (var i = 0; i < brandData1.length; i++) {
        Brand_p brData = Brand_p(
          name: brandData1[i]['name'].toString(),
          logourl: brandData1[i]['logourl'].toString(),
          password: brandData1[i]['password'].toString(),
        );

        brandData.add(brData);
      }
      for (var i = 0; i < sizeData1.length; i++) {
        Size_P sData = Size_P(
          name: sizeData1[i]['name'].toString(),
          number: sizeData1[i]['number'].toString(),
          selected: false,
        );
        sizeData.add(sData);
      }
      for (var i = 0; i < colorData1.length; i++) {
        Colorway colData = Colorway(
          name: colorData1[i]['name'],
          color: HexColor(
              colorData1[i]['color'].toString().replaceAll(RegExp('#'), '')),
          color_code: colorData1[i]['color'].toString(),
          selected: false,
        );

        colorData.add(colData);
      }
    });
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          if (xfilePick.length <= 5 &&
              (selectedImages.length + xfilePick.length) <= 5) {
            for (var i = 0; i < xfilePick.length; i++) {
              selectedImages.add(File(xfilePick[i].path));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select Only 5 Images')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  String getSelectedItemCount() {
    return selectItems.isNotEmpty
        ? "${selectItems.length} item selected"
        : "No item selected";
  }

  void doMultiSelection(int path) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectItems.contains(path)) {
          selectItems.remove(path);
        } else {
          selectItems.add(path);
        }
      });
    } else {
      //
    }
  }

  void doSizeMultiSelection(int path) {
    if (isSizeMultiEnabled) {
      setState(() {
        if (selectSizeItems.contains(path)) {
          selectSizeItems.remove(path);
        } else {
          selectSizeItems.add(path);
        }
      });
    } else {
      //
    }
  }

  void _updateLocation(PointerEvent details) {}
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
