import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Hide the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Table test',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MyData _data = MyData();

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Dessert d) getField, int columnIndex,
      bool ascending) {
    _data._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table test'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          PaginatedDataTable(
            source: _data,
            header: const Text('My Products'),
            columns: [
              DataColumn(
                  label: const Text('ID'),
                  onSort: (int columnIndex, bool ascending) =>
                      _sort<num>((Dessert d) => d.id, columnIndex, ascending)),
              DataColumn(
                  label: Text('Name'),
                  onSort: (int columnIndex, bool ascending) => _sort<String>(
                      (Dessert d) => d.title, columnIndex, ascending)),
              DataColumn(
                  label: Text('Price'),
                  onSort: (int columnIndex, bool ascending) => _sort<num>(
                      (Dessert d) => d.price, columnIndex, ascending))
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 4,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            showCheckboxColumn: false,
          ),
        ],
      ),
    );
  }
}

class Dessert {
  Dessert(this.id, this.title, this.price);
  final int id;
  final String title;
  final double price;

  bool selected = false;
}

// The "soruce" of the table
class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Dessert> _data = <Dessert>[
    Dessert(1, 'taest', 20),
    Dessert(2, 'tesasst', 21),
    Dessert(3, 'astest', 22),
    Dessert(4, 'retest', 23),
    Dessert(5, 'fdsfstest', 24),
    Dessert(6, 'eretest', 25),
    Dessert(7, 'rytest', 26),
    Dessert(8, 'rtrtest', 27),
    Dessert(9, 'aetest', 28),
    Dessert(10, 'ghtest', 29),
  ];

  void _sort<T>(Comparable<T> Function(Dessert d) getField, bool ascending) {
    _data.sort((Dessert a, Dessert b) {
      if (!ascending) {
        final Dessert c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    final Dessert data = _data[index];
    return DataRow(cells: [
      DataCell(Text(data.id.toString()), onTap: () {
        print(data.title);
      }),
      DataCell(Text(data.title)),
      DataCell(Text(data.price.toString())),
    ]);
  }
}
