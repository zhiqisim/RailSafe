import 'package:flutter/material.dart';
import 'package:elderest/services/authentication.dart';
import 'package:elderest/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'RailSafe',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Colors.red,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
