import 'package:flutter/material.dart';

//All Api placed in this class.
//Just replace with existing base url here.
class APIS {
  static var baseurl = "https://jupiters.tech:8081/";

//GHK_Staff APIS
  static var login = baseurl + "login";
  static var register = baseurl + "register";
  static var forgotPassword = baseurl + "forgotPassword";
  static var createMeeting = baseurl + "createMeeting";
  static var deleteMeeting = baseurl + "deleteMeeting";
  static var updateMeeting = baseurl + "updateMeeting";
  static var changePassword = baseurl + "changePassword";
  static var meetingList = baseurl + "listMeetings?userId=";
  static var checkMeeting = baseurl + "checkMeeting?meetingId=";
  static var profile = baseurl + "userProfileDetails?userId=";
}

class SIGNALING {
  static var serverURL = 'https://jupiters.tech:8081';
}

//We have used Shared preferance for storing some low level data.
//For this we have used this keys.
class DefaultKeys {
  static var userName = "name";
  static var userEmail = "email";
  static var userId = "userId";
  static var userImage = "image";
  static var userAddress = "address";
  static var userPhone = "phone";
  static var isLoggedIn = "isLoogedIn";
  static var pushToken = "firebaseToken";
}

//This is the app colors.
//You can change your theme color based on your requirements.
class AppColor {
  //This is the main application theme color.

  static var themeColor = HexToColor("#cf4647");
  // static var themeColor = HexToColor("#ED1B41");
  // static var themeColor = HexToColor("#3787ac");
  static var pagingIndicatorColor = Colors.red;
  static var black = HexToColor("#000000");
  static var orangeDeep = Colors.deepOrange;
  static var colorGyay_100 = Colors.grey[100];
  static var white = Colors.white;
  static var amber = Colors.amber;
  static var grey = Colors.grey;
  static var black87 = Colors.black87;
  static var red = Colors.red;
  static var black38 = Colors.black38;
  static var deepOrange = Colors.deepOrange;
  static var black54 = Colors.black54;
  static var orange = Colors.orange;
  static var teal = Colors.teal; //Google plus icon color

}

//Convert color from hax color.
class HexToColor extends Color {
  static _hexToColor(String code) {
    return int.parse(code.substring(1, 7), radix: 16) + 0xFF000000;
  }

  HexToColor(final String code) : super(_hexToColor(code));
}

class AppRoute {
  static const dashboard = '/dashboard';
  static const tabbar = '/tabbar';
  static const login = '/login';
  static const signUp = '/signUp';
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class SharedKeys {
  static var userId = "userID";
  static var profile = "profile";
  static var name = "name";
  static var email = "email";
  static var phone = "phone";
  static var address = "address";
}

double setWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double setHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
