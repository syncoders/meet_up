import 'package:flutter/material.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Screens/TabBarScreen/TabBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: AppColor.themeColor),
      debugShowCheckedModeBanner: false,
      home: TabBarScreen(),
    );
  }
}
