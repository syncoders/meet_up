import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/SocketConnection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  static final SharedManager shared = SharedManager._internal();

  factory SharedManager() {
    return shared;
  }

  SharedManager._internal();

  var fontFamilyName = "Quicksand";
  bool isOpenMessageScreen = false;
  var currentIndex = 1;
  var direction = TextDirection.ltr;
  var ipAddress = "";

  String name;
  String mobile;
  String specility;
  bool isDoctor;
  bool isLogedIn = false;
  var userId = '';
  var userName = '';
  String meetingID = '';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  SocketManager manager = SocketManager();
  ValueNotifier<Locale> locale = new ValueNotifier(Locale('en', ''));

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Future<bool> set(key, value) async {
    final shareSave = await SharedPreferences.getInstance();

    return shareSave.setString(key, value);
  }

  Future<String> get(key) async {
    final shareSave = await SharedPreferences.getInstance();
    return shareSave.getString(key);
  }

  showAlertDialog(String message, BuildContext context) {
    // flutter defined function
    return Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

//Replace or change your STUN or TURN Server here
  Map<String, dynamic> iceServers = {
    'iceServers': [
      {'url': 'stun:stun2.l.google.com:19302'},
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
       */
    ]
  };

  final Map<String, dynamic> config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };
}
