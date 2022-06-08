import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AboutMainPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyLogin(),
    );
  }
}
