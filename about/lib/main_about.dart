import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AboutMainPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (context) => const MyLogin(),
          'register': (context) => const MyRegister(),
        });
  }
}
