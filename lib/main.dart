import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finTrack/category.dart';
import 'package:finTrack/setting.dart';
import 'package:finTrack/expense_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FinTrackScreen(),
    );
  }
}

class FinTrackScreen extends StatefulWidget {
  const FinTrackScreen({super.key});

  @override
  _FinTrackScreenState createState() => _FinTrackScreenState();
}

class _FinTrackScreenState extends State<FinTrackScreen> {
  List<String> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses = prefs.getStringList('expenses') ?? [];

    });
  }

  Future<void> _saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('expenses', expenses);
  }

  void _addExpense(String name, double amount, String category) {
    setState(() {
      expenses.add('$name  ₹${amount.toStringAsFixed(2)}  ($category)');
    });
    _saveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(44, 44, 44, 1),
        foregroundColor: Colors.white,
        centerTitle: true,
        title:const Text(
            'FinTrack',
            textAlign: TextAlign.center,
            style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 30.0,
            fontFamily: 'Pacifico',
            fontWeight: FontWeight.normal,
          ),
        ),

      ),

      drawer: Drawer(
        surfaceTintColor:const Color.fromRGBO(18, 18, 18, 1),
        backgroundColor:const Color.fromRGBO(18, 18, 18, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 44, 44, 1),
              ),
              child: Text(
                'Track Drawer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text('Category Expenses',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CategoryWiseDisplay()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pie_chart, color: Colors.white,),
              title: const Text('Expense View',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExpenseView())  );
              },
            ),
            const Divider(color: Colors.white12, indent: 20, endIndent: 20, thickness: 1,),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        color:const Color.fromRGBO(18, 18, 18, 1),
        child: ListView.builder(
          itemCount: expenses.length,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemBuilder: (context, index) {
            return Center(
              child: ListTile(
                leading:const Icon(Icons.numbers,color: Colors.white,),
                title: Text(expenses[index],style:const TextStyle(color: Colors.white),),
                onLongPress: () {
                  _showDeleteDialog(context, index);
                },
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromRGBO(3, 218, 197, 1),
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        child: const Icon(Icons.edit, color: Colors.black,),
      ),
    );
  }



  Future<void> _showAddExpenseDialog(BuildContext context) async {
    String name = '';
    double expense = 0.0;
    String category = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(56, 56, 56, 1),
          surfaceTintColor: const Color.fromRGBO(56, 56, 56, 1),
          title: const Text('Add Expense',style: TextStyle(color: Colors.white),),
          content: Column(

            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                style:const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                style:const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Expense', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  expense = double.tryParse(value) ?? 0.0;
                },
              ),
              TextField(
                style:const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Category', hintText: "i.e Food", labelStyle: TextStyle(color: Colors.white),hintStyle: TextStyle(color: Colors.white),),
                onChanged: (value) {
                  category = value.replaceAll(" ", "");
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK',style: TextStyle(color: Colors.white),),
              onPressed: () {
                _addExpense(name, expense, category);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:const Color.fromRGBO(44, 44, 44, 1),
          surfaceTintColor:const Color.fromRGBO(44, 44, 44, 1),
          title:const Text('Delete Item?',style: TextStyle(color: Colors.white),),
          content:const Text('Are you sure you want to delete this item?',style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('Cancel',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  expenses.removeAt(index);
                });
                _saveExpenses();
                Navigator.of(context).pop();
              },
              child:const Text('Delete',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }
}
