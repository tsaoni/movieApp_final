import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'form.dart';
import 'login.dart';
import 'revise.dart';
import 'show_movie.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const routeName = '/about';
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return const Scaffold(
          // title: _title,
          body: MyStatefulWidget(),
        );
      },
    );

  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 3){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const MyLogin()),
          ModalRoute.withName('/'),
        );
        /*
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => const MyLogin(),
        ),
        );
         */
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: <Widget>[
          const TabsScreen(),
          const FormPage(),
          RevisePage(),
          const MyLogin(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'comment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'add comment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'personal info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'logout',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(100, 100, 100, 1),
        selectedItemColor: Color.fromRGBO(116, 196, 199, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}

