import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Screens/LoginScreen.dart';
import 'package:meet_up/Screens/SignupPage.dart';
import 'package:meet_up/Socket/SharedManaged.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

//This is the common function which works whole application, which set Text with different font and color.
setCommonText(String title, dynamic color, dynamic fontSize, dynamic fontweight,
    dynamic noOfLine, TextAlign alignment) {
  return new AutoSizeText(
    title,
    style: new TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontweight,
      fontFamily: SharedManager.shared.fontFamilyName,
    ),
    maxLines: noOfLine,
    textAlign: alignment,
    overflow: TextOverflow.ellipsis,
    wrapWords: true,
  );
}

setCommonAppBar(String title, bool isNotificationShow, BuildContext context,
    List<Widget> action) {
  return new AppBar(
      title: setCommonText(
          title, AppColor.white, 20.0, FontWeight.w500, 1, TextAlign.center),
      backgroundColor: AppColor.themeColor,
      elevation: 0.0,
      actions: action);
}

showSnackbar(String value, GlobalKey<ScaffoldState> key) {
  key.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 15),
      content: new Row(
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            height: 18.0,
            width: 18.0,
          ),
          SizedBox(width: 15),
          new Expanded(
              child: setCommonText(value, AppColor.white, 15.0, FontWeight.w500,
                  2, TextAlign.start))
        ],
      )));
}

hideSnackBar(GlobalKey<ScaffoldState> key) {
  key.currentState.hideCurrentSnackBar();
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(em);
}

orderIsNotAvailable(String stringMessage, String image, BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    padding: new EdgeInsets.all(25),
    color: AppColor.white,
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new AutoSizeText(
          stringMessage,
          textDirection: SharedManager.shared.direction,
          style: new TextStyle(
            color: AppColor.red,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            fontFamily: SharedManager.shared.fontFamilyName,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          wrapWords: true,
        ),
        SizedBox(
          height: 15,
        ),
        new Icon(
          Icons.fastfood,
          size: 35,
        )
        // setCommonText(stringMessage, AppColor.red, 17.0, FontWeight.w500, 2)
      ],
    ),
  );
}

//If application works with login or registrations set this widget.
setLockedAccessWidgets(
    BuildContext context, bool isFromCart, String messageTitle, String status) {
  return new Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    // color: Colors.red,
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage((status == '0')
                      ? 'Assets/Images/lockedAccess.png'
                      : 'Assets/Images/envelope.png'),
                  fit: BoxFit.cover)),
        ),
        SizedBox(height: 10),
        new Padding(
          padding: new EdgeInsets.only(left: 35, right: 35),
          child: new Text(
            '$messageTitle',
            style: new TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontFamily: SharedManager.shared.fontFamilyName,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 35),
        new GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName(AppRoute.login));
          },
          child: new Container(
            height: 46,
            width: 160,
            decoration: BoxDecoration(
                color: AppColor.themeColor,
                borderRadius: BorderRadius.circular(23)),
            child: new Center(
                child: setCommonText(
              'Login',
              Colors.white,
              18.0,
              FontWeight.w400,
              1,
              TextAlign.start,
            )),
          ),
        ),
        SizedBox(height: 25),
        new Padding(
          padding: new EdgeInsets.only(left: 20, right: 20),
          child: new GestureDetector(
            onTap: () {
              // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => SignupPage()),
              //     ModalRoute.withName(AppRoute.signUp));
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SignupPage()));
            },
            child: new Center(
              child: setCommonText('Don\'t have an account?', Colors.grey, 17.0,
                  FontWeight.w600, 1, TextAlign.start),
            ),
          ),
        )
      ],
    ),
  );
}
