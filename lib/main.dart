import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_balance_app/database_helper.dart';
import 'package:my_balance_app/transection_model.dart';
import 'package:my_balance_app/widgets/custom_button.dart';
import 'package:my_balance_app/widgets/custom_textfield.dart';

import 'widgets/custom_tile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// Main widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'الوارد والمصروف',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

// Home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

// Home page state
class MyHomePageState extends State<MyHomePage> {
  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Text editing controller
  final TextEditingController _ncontroller = TextEditingController();
  final TextEditingController _acontroller = TextEditingController();

  int total = 0;

  @override
  void initState() {
    super.initState();
    calcTotal();
  }

  calcTotal() async {
    int totalSum = (await _dbHelper.getSum())[0]['TOTAL'];
    debugPrint(totalSum.toString());
    setState(() {
      total = totalSum;
    });
  }

  void addAmount() {
    // Get the name from the controller
    final String name = _ncontroller.text;
    final String amount = _acontroller.text;

    _addItem(name, amount, Colors.green.value);
  }

  void subtractAmount() {
    // Get the name from the controller
    final String name = _ncontroller.text;
    String amount = _acontroller.text;

    amount = (int.parse(amount) * -1).toString();
    _addItem(name, amount, Colors.red.value);
  }

  // Add a new item to the database
  void _addItem(name, amount, int colorValue) async {
    // Validate the input
    if (name.isEmpty || amount.isEmpty) return;

    var date = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm');
    var formattedDate = formatter.format(date);
    // Create a new item
    final Item item = Item(
      name: name,
      amount: int.parse(amount),
      date: formattedDate,
      color: colorValue,
    );
    // Insert the item to the database
    await _dbHelper.insertItem(item);
    await calcTotal();
    // Clear the controller
    _ncontroller.clear();
    _acontroller.clear();

    // Update the UI
    setState(() {});
  }

// Delete an item from the database
  void _deleteItem(Item item) async {
    // Delete the item from the database
    await _dbHelper.deleteItem(item);

    // Update the UI
    setState(() {});
  }

  // Build the list item widget
  Widget _buildListItem(Item item) {
    return CustomTile(
      dkey: Key(item.id.toString()),
      title: item.name,
      amountTxt: item.amount.toString(),
      date: item.date,
      colorValue: item.color,
      onDismissed: (direction) => _deleteItem(item),
    );
  }

  // Build the list view widget
  Widget _buildListView() {
    return FutureBuilder<List<Item>>(
      future: _dbHelper.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Item> items = snapshot.data!;
          return Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildListItem(items[index]);
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الوارد و المصروف',
          style: TextStyle(color: Colors.indigo, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: ThemeData.light().scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(label: "نوع الصرف", controller: _ncontroller),
            CustomTextField(label: "المبلغ", controller: _acontroller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  color: Colors.red,
                  text: "طرح",
                  icon: const Icon(Icons.remove),
                  onPressed: subtractAmount,
                ),
                CustomButton(
                  color: Colors.green,
                  text: "أضافة",
                  icon: const Icon(Icons.add),
                  onPressed: addAmount,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: SizedBox(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      '$total دينار',
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildListView(),
          ],
        ),
      ),
    );
  }
}
