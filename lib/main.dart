import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:collection';
import 'package:update_product/app_color.dart';

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

List<File> selectedImages = [];
final picker = ImagePicker();

String dropdownvalue = 'Item 1';

String brandValue = 'brand 1';

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
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
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
                              items: brands.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
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
                                      j < arry_colors.length;
                                      j++) ...[
                                    GridTile(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            arry_colors[j]["selected"] =
                                                !bool.parse(arry_colors[j]
                                                        ["selected"]
                                                    .toString());

                                            isMultiSelectionEnabled = true;
                                            doMultiSelection(j);
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            arry_colors[j]["selected"] =
                                                !bool.parse(arry_colors[j]
                                                        ["selected"]
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
                                                color: HexColor(arry_colors[j]
                                                        ["color_code"]
                                                    .toString()
                                                    .replaceAll(
                                                        RegExp('#'), ''))),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      arry_colors[j]
                                                                  ["color_code"]
                                                              .toString() +
                                                          " " +
                                                          arry_colors[j]
                                                                  ["color_name"]
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 6.0,
                                                          color: arry_colors[j][
                                                                          "color_name"]
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
                                                        arry_colors[j]
                                                                ["selected"]
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
                              for (int i = 0; i < arry_sizes.length; i++) ...[
                                GridTile(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            arry_sizes[i]["selected"] =
                                                !bool.parse(arry_sizes[i]
                                                        ["selected"]
                                                    .toString());
                                            isSizeMultiEnabled = true;
                                            doSizeMultiSelection(i);
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            arry_sizes[i]["selected"] =
                                                !bool.parse(arry_sizes[i]
                                                        ["selected"]
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
                                                          arry_sizes[i]
                                                                  ["selected"]
                                                              .toString())
                                                      ? AppColor.secondary
                                                      : Colors.grey,
                                                  radius: 20,
                                                  child: Text(
                                                    arry_sizes[i]["size_no"]
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
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
