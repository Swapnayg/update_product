import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:collection';
import 'package:update_product/app_color.dart';
import 'package:update_product/category.dart';
import 'package:update_product/colorway.dart';
import 'package:update_product/brand.dart';
import 'package:update_product/size.dart';
import 'package:update_product/imgbbResponseModel.dart';
import 'package:update_product/admin_login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final List<Category_P> categoryData = [];
final List<Brand_p> brandData = [];
final List<Size_P> sizeData = [];
final List<Colorway> colorData = [];

List<PlatformFile> selectedImages = [];
final picker = ImagePicker();
Dio dio = Dio();

int dropdownvalue = 0;

int brandValue = 0;

int? _currentSelectedIndex;
HashSet selectItems = HashSet();
HashSet selectSizeItems = HashSet();
bool isMultiSelectionEnabled = false;
bool isSizeMultiEnabled = false;
bool delay = true;
ImgbbResponseModel? imgbbResponse;

HashSet image_urls = HashSet();

class _MyHomePageState extends State<MyHomePage> {
  final _productname = TextEditingController();
  final _productdesc = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _productname.dispose();
    _productdesc.dispose();
  }

  @override
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
                              controller: _productname,
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: '',
                              ),
                            ))),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Product Description'),
                        subtitle: SizedBox(
                            width: MediaQuery.of(context).size.width * .71,
                            child: TextFormField(
                              maxLines: 8,
                              controller: _productdesc,
                              autofocus: false,
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
                                  value: index,
                                  child:
                                      Text(categoryData[index].name.toString()),
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
                                  value: index,
                                  child: Text(brandData[index].name.toString()),
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
                                                      "${colorData[j].name} ${colorData[j].color_code}",
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
                            height: 250.0,
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
                                      final file = selectedImages[index];
                                      return Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    deleteimage(index);
                                                  },
                                                  icon: Icon(Icons.close),
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                alignment: Alignment.center,
                                                child:
                                                    Image.memory(file.bytes!),
                                              )),
                                            ],
                                          ));
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
                      onPressed: startuploading,
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpeg', 'png', 'webp', 'jpg']);

    setState(
      () {
        if (result != null) {
          if (result.files.isNotEmpty) {
            if (result.files.length <= 5 &&
                (selectedImages.length + result.files.length) <= 5) {
              for (var i = 0; i < result.files.length; i++) {
                selectedImages.add(result.files[i]);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select Only 5 Images')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        }
      },
    );
  }

  String getSelectedItemCount() {
    return selectItems.isNotEmpty
        ? "${selectItems.length} item selected"
        : "No item selected";
  }

  Future<void> uploadImageFile(List<PlatformFile> imagesList) async {
    DateTime now = DateTime.now();
    for (int j = 0; j < imagesList.length; j++) {
      FormData formData = FormData.fromMap({
        "key": "cc4c5920e77b36355db28b10c5f35e17",
        "image": base64Encode(selectedImages[j].bytes!),
        "name": "image_$now$j"
      });
      Response response = await dio.post(
        "https://api.imgbb.com/1/upload",
        data: formData,
      );
      if (response.statusCode != 400) {
        imgbbResponse = ImgbbResponseModel.fromJson(response.data);
        setState(() {
          image_urls.add(imgbbResponse!.data.displayUrl);
        });
      } else {
        setState(() {});
      }
    }
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

  void deleteimage(int path) {
    List<PlatformFile> selectedImages1s = [];
    setState(() {
      for (int j = 0; j < selectedImages.length; j++) {
        if (j != path) {
          selectedImages1s.add(selectedImages[j]);
        }
      }
      selectedImages = selectedImages1s;
    });
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

  startuploading() async {
    if (_productname.text.isEmpty == false) {
      if (_productdesc.text.isEmpty == false) {
        if (dropdownvalue != 0) {
          if (brandValue != 0) {
            if (selectItems.isEmpty == false) {
              if (selectSizeItems.isEmpty == false) {
                if (selectedImages.isEmpty == false) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Center(child: CircularProgressIndicator());
                      });
                  await uploadImageFile(selectedImages);

                  var data = {
                    "call": "insert",
                    "p_name": _productname.text,
                    "p_description": _productdesc.text,
                    "p_category": categoryData[dropdownvalue].name.toString(),
                    "p_brand": brandData[brandValue].name.toString(),
                    "p_images": jsonEncode(image_urls.toList()),
                    "p_sizes": jsonEncode(selectSizeItems.toList()),
                    "p_colors": jsonEncode(selectItems.toList()),
                    "p_company": "abcd",
                  };
                  await http
                      .post(
                          Uri.parse(
                              "https://script.google.com/macros/s/AKfycbwkmTCZqEbhk_GB2yUa5clPPnXDG0zP7OEU3jtVRGBaFELX9B6q1X-EL6PScGbQbOpd/exec"),
                          body: (data))
                      .then((response) async {
                    if (response.statusCode == 302) {
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AdminLoginPage()));
                    }
                  });
                } else {
                  _showAlert(context, "Please add images.");
                }
              } else {
                _showAlert(context, "Please select sizes.");
              }
            } else {
              _showAlert(context, "Please select colors.");
            }
          } else {
            _showAlert(context, "Please select brand.");
          }
        } else {
          _showAlert(context, "Please select category.");
        }
      } else {
        _showAlert(context, "Please enter product description.");
      }
    } else {
      _showAlert(context, "Please enter product name.");
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

void _showAlert(BuildContext context, text) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Error:"),
            content: Text(text),
          ));
}
