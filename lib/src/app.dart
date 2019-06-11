import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_db/src/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false);
  }
}
