import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
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

List<File> selectedImages = [];
final picker = ImagePicker();

String dropdownvalue = 'Item 1';

// List of items in our dropdown menu
var items = [
  'Item 1',
  'Item 2',
  'Item 3',
  'Item 4',
  'Item 5',
];

String brandValue = 'brand 1';

// List of items in our dropdown menu
var brands = [
  'brand 1',
  'brand 2',
  'brand 3',
  'brand 4',
  'brand 5',
];

class _MyHomePageState extends State<MyHomePage> {
  final TextStyle textstyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final InputDecoration decoration = InputDecoration(
    border: OutlineInputBorder(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                    title: Text('Select Category'),
                    subtitle: Container(
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
                    title: Text('Select Brands'),
                    subtitle: Container(
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Select Image from Gallery and Camera'),
                  onPressed: () {
                    getImages();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: SizedBox(
                    width: 300.0,
                    child: selectedImages.isEmpty
                        ? const Center(child: Text('Sorry nothing selected!!'))
                        : GridView.builder(
                            itemCount: selectedImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: kIsWeb
                                      ? Image.network(
                                          selectedImages[index].path)
                                      : Image.file(selectedImages[index]));
                            },
                          ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  color: Colors.blue,
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
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
