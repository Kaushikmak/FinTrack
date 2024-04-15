import 'package:flutter/material.dart';
import 'package:finTrack/main.dart';
import 'package:finTrack/category.dart';
import 'package:finTrack/expense_view.dart';
import 'package:url_launcher/url_launcher.dart';



class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(44, 44, 44, 1),
        foregroundColor: Colors.white,
        centerTitle: true,
        title:const Text("Settings",textAlign: TextAlign.center,),
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
        child: ListView(
          children: [
            const ListTile(
              title: Center(child: Text("Check out fintrack on socials",style: TextStyle(color: Colors.white),)),
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.deepPurple,),
              title: const Text('Instagram',style: TextStyle(color: Colors.white),),
              onTap: () {
                var urlInsta = Uri.parse('https://www.instagram.com/');
                _launchURL(urlInsta);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.deepPurple,),
              title: const Text('LinkedIn',style: TextStyle(color: Colors.white),),
              onTap: () {
                var urlLinkedin = Uri.parse('https://www.linkedin.com/');
                _launchURL(urlLinkedin);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.deepPurple,),
              title: const Text('X',style: TextStyle(color: Colors.white),),
              onTap: () {
                var urlTwitter = Uri.parse('https://twitter.com/');
                _launchURL(urlTwitter);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.deepPurple,),
              title: const Text('GitHub',style: TextStyle(color: Colors.white),),
              onTap: () {
                var urlGithub = Uri.parse('https://github.com/Kaushikmak');
                _launchURL(urlGithub);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
