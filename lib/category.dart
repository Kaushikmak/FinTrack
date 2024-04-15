import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finTrack/main.dart';
import 'package:finTrack/setting.dart';
import 'package:finTrack/expense_view.dart';

class CategoryWiseDisplay extends StatefulWidget {
  const CategoryWiseDisplay({Key? key}) : super(key: key);

  @override
  _CategoryWiseDisplayState createState() => _CategoryWiseDisplayState();
}

class _CategoryWiseDisplayState extends State<CategoryWiseDisplay> {
  List<String> categories = [];
  Map<String, List<String>> expenses = {};

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('expenses', categories);
  }

  Future<void> _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      categories = prefs.getStringList('expenses') ?? [];
      for (int i = 0; i < categories.length; i++) {
        var cat = categories[i].split(RegExp(r'\s+')).where((element) => element.isNotEmpty).toList().last.replaceAll(RegExp(r'[()]'), '');
        expenses[cat] = prefs.getStringList(cat) ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Category",textAlign: TextAlign.center,),
        backgroundColor:const Color.fromRGBO(44, 44, 44, 1),
        foregroundColor: Colors.white,
        centerTitle: true,
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
          itemBuilder: (context, index) {
            String category = expenses.keys.elementAt(index);
            return GestureDetector(
              onTap: () {
                _showExpensePopup(context, category);
              },
              onLongPress: (){
                _showDeleteCategoryButton(context, category);
              },
              child: Card(
                color:const Color.fromRGBO(37, 37, 37, 1),
                elevation: 10,
                child: ListTile(
                  title: Text(category.toUpperCase(),style:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  subtitle: Text("Total Expenses: ₹${calculateTotalExpense(category)}",style:const TextStyle(color: Colors.white),),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 40,
        surfaceTintColor:const Color.fromRGBO(18, 18, 18, 1),
        color:const Color.fromRGBO(18, 18, 18, 1),
        child: Container(
          alignment: Alignment.topCenter,
            child:const Text("""long press to delete  |  tap for details""",style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  double calculateTotalExpense(String category){
    double sum = 0.0;

    for(int i=0; i<categories.length; i++){
      var categoryVar = categories[i].split(RegExp(r'\s+')).where((element) => element.isNotEmpty).toList().last.replaceAll(RegExp(r'[()]'), '');
      if(categoryVar.toString() == category){
        try{
          String x = categories[i].split(RegExp(r'\s+')).where((element) => element.isNotEmpty && element.contains('₹')).toList()[0].replaceAll("₹", "");
          var y = double.parse(x);
          sum += y;
        }on FormatException{
          null;
        }
      }
    }
    return sum;
  }

  Future<void> _showExpensePopup(BuildContext context, String category) async {
    var searchCategoryInList = "($category)";
    List<String> myListreq = categories.where((element) => element.contains(searchCategoryInList)).toList();
    if (myListreq.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromRGBO(56, 56, 56, 1),
            surfaceTintColor: const Color.fromRGBO(56, 56, 56, 1),
            title: Text('Expenses for $category',style:const TextStyle(color: Colors.white),),
            content: SingleChildScrollView(
              child: ListBody(
                children: List.generate(myListreq.length, (index) => ListTile(
                  leading:const Icon(Icons.numbers,color: Color.fromRGBO(187, 134, 252, 1),),
                  title: Text(myListreq[index].split("₹")[0],style:const TextStyle(color: Colors.white),),
                  subtitle: Text('Price ₹${myListreq[index].split("₹")[1].split("(")[0]}',style:const TextStyle(color: Colors.white),),
                ))
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close',style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Expenses'),
            content: Text('There are no expenses recorded for $category'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showDeleteCategoryButton(BuildContext context, String category) async{
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: const Color.fromRGBO(56, 56, 56, 1),
            surfaceTintColor: const Color.fromRGBO(56, 56, 56, 1),
            title: Text("Delete $category",style:const TextStyle(color: Colors.white),),
            content:const Text('Are you sure you want to delete this category?',style: TextStyle(color: Colors.white),),
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
                    List<String> itemsToremove = categories.where((element) => element.contains(category)).toList();
                    // print(itemsToremove);
                    categories.removeWhere((item) => itemsToremove.contains(item));
                  });
                  _saveExpenses();
                  Navigator.of(context).pop();
                },
                child:const Text('Delete',style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        }
    );

  }


}
