import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Screens/JoinMeeting.dart';
import 'package:meet_up/Screens/TabBarScreen/MeetingPage.dart';
import 'package:meet_up/Screens/TabBarScreen/ProfilePage.dart';
import 'package:meet_up/Socket/SharedManaged.dart';

void main() => runApp(new TabBarScreen());

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Widget> _children = [MeetingPage(), JoinMeeting(), ProfilePage()];

  _onTapped(int index) {
    setState(() {
      print("index $index");
      SharedManager.shared.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return new Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _children[SharedManager.shared.currentIndex],
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, //if you remove this tab bar will white.
        currentIndex: SharedManager.shared.currentIndex,
        onTap: _onTapped,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.local_shipping, size: 25),
              activeIcon: new Icon(Icons.local_shipping,
                  color: AppColor.themeColor, size: 25),
              label: 'Meetings'),
          BottomNavigationBarItem(
              icon: new Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey[400],
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            3.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                    color: AppColor.themeColor,
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  child: new Center(
                    child: new Icon(
                      Icons.home,
                      color: AppColor.white,
                      size: 23,
                    ),
                  )),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person, size: 25),
              activeIcon:
                  new Icon(Icons.person, color: AppColor.themeColor, size: 25),
              label: 'Profile'),
        ],
      ),
    );
  }
}
