import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finTrack/main.dart';
import 'package:finTrack/category.dart';
import 'package:finTrack/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({Key? key}) : super(key: key);

  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  List<String> expenses = [];
  Map<String, List<String>> categories = {};
  List finalCategory = [];
  Map<String, int> categoryValuePair = {};
  String containerText = '';

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses = prefs.getStringList('expenses') ?? [];
      for (int i = 0; i < expenses.length; i++) {
        var cat = expenses[i]
            .split(RegExp(r'\s+'))
            .where((element) => element.isNotEmpty)
            .toList()
            .last
            .replaceAll(RegExp(r'[()]'), '');
        categories[cat] = prefs.getStringList(cat) ?? [];
      }
      finalCategory = (categories.keys.toList());
      for (String item in expenses) {
        String bracketElement =
            RegExp(r'\((.*?)\)').firstMatch(item)?.group(1) ?? '';
        categoryValuePair[bracketElement] =
            (categoryValuePair[bracketElement] ?? 0) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Expense View",textAlign: TextAlign.center,),
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
          alignment: Alignment.topCenter,
          color:const Color.fromRGBO(18, 18, 18, 1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container(
                margin:const EdgeInsets.symmetric(vertical: 5),
                child: _buildcharts(),
                )
              ),
              Expanded(child: Container(
                margin:const EdgeInsets.only(top: 10),
                child: _buildContainer(),
              )
              ),
            ],
          )),

      bottomNavigationBar: BottomAppBar(
        height: 40,
        surfaceTintColor:const Color.fromRGBO(18, 18, 18, 1),
        color:const Color.fromRGBO(18, 18, 18, 1),
        child: Container(

          alignment: Alignment.topCenter,
          child:const Text("""tap on pie chart for details""",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Widget _buildcharts() {
    return Center(
      child: PieChart(
        PieChartData(
            sections: piechartsection(),
            pieTouchData: PieTouchData(touchCallback: (event, touchResponse) {
              if (event is FlTapUpEvent &&
                  touchResponse != null &&
                  touchResponse.touchedSection != null) {
                int tappedIndex =
                    touchResponse.touchedSection!.touchedSectionIndex;
                String tappedTitle =
                    piechartsection()[tappedIndex].title ?? '';
                setState(() {
                  containerText = tappedTitle;

                });
              }
            })),
      ),
    );
  }

  List<PieChartSectionData> piechartsection() {
    List<PieChartSectionData> sections = [];
    for (int i = 0; i < categoryValuePair.length; i++) {
      sections.add(
        PieChartSectionData(
          value: categoryValuePair.values.toList()[i].toDouble(),
          color: Colors.accents[i % Colors.accents.length],
          title:
          "${finalCategory[i]}\n${_perecntageCalculator(categoryValuePair.keys.toList()[i].toString(), i)}%",
          radius: 150,
        ),
      );
    }
    return sections;
  }

  String _perecntageCalculator(String category, int index) {
    double totalElements =
    categoryValuePair.values.toList().reduce((value, element) => value + element).toDouble();
    double numerator = categoryValuePair.values.toList()[index].toDouble();
    String percentage = ((numerator / totalElements) * 100).toStringAsFixed(2);
    return percentage;
  }

  Widget _buildContainer() {
    try{
      String categorySelectedOnPieChart = containerText.replaceAll("\n", '').split(RegExp(r'\d+')).where((element) => element.isNotEmpty).toList()[0].replaceAll(" ", '') ?? '';
      int? numberOfelements = categoryValuePair[categorySelectedOnPieChart];
      // print(expenses.where((element) => element.contains('food')).toList());
      if (containerText.isNotEmpty) {
        return Container(
          color:const Color.fromRGBO(18, 18, 18, 1),
          margin:const EdgeInsets.only(left: 5, right: 5),
          height: MediaQuery.of(context).size.height*0.35,
          child: ListView.builder(
            itemCount: numberOfelements,
            itemBuilder: (context, index) {
              return Container(
                margin:const EdgeInsets.symmetric(vertical: 5),
                color:const Color.fromRGBO(37, 37, 37, 1),
                child: ListTile(
                  leading:const Icon(Icons.label_important_outline, color: Colors.white,),
                  title: Text(expenses.where((element) => element.contains(categorySelectedOnPieChart)).toList()[index].toString().split("₹")[0].trim(),style:const TextStyle(color: Colors.white),),
                  trailing: Text("₹${expenses.where((element) => element.contains(categorySelectedOnPieChart)).toList()[index].split("₹")[1].replaceAll(RegExp(r'\([^)]*\)'), '').trim()}",style:const TextStyle(color: Colors.white),),


                ),
              );
            },
          ),
        );
      } else {
        return Container();
      }
    }on RangeError{
      null;
      return Container();
    }



  }

}
