import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Screens/LoginScreen.dart';
import 'package:meet_up/Socket/SharedManaged.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var message = 'Update your password using your current password';
  int state = 1;
  var email = '';
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswirdController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isValidate() {
    if (this.passwordController.text == '') {
      SharedManager.shared
          .showAlertDialog('Please enter current password', context);
      return false;
    } else if (this.newPasswirdController.text == '') {
      SharedManager.shared
          .showAlertDialog('Please enter new password', context);
      return false;
    }
    return true;
  }

  _changePassword() async {
    final param = {
      "oldPassword": "${this.passwordController.text}",
      "newPassword": "${this.newPasswirdController.text}",
      "email": "",
      "userId": SharedManager.shared.userId,
    };

    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.changePassword(param).then((value) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if (value.code == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
        SharedManager.shared
            .showAlertDialog('Password Chnaged Successfully!!!', context);
      } else {
        SharedManager.shared
            .showAlertDialog('Failed to change password', context);
      }
    });
  }

  _getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    this.email = prefs.getString('${DefaultKeys.userEmail}') ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEmail();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.35;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: BezierClipper(state),
                child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    width: setWidth(context),
                    color: AppColor.themeColor,
                    height: height,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            setCommonText('Welcom To', AppColor.white, 30.0,
                                FontWeight.bold, 1, TextAlign.start),
                            setCommonText('MeetUp', AppColor.white, 30.0,
                                FontWeight.bold, 1, TextAlign.start),
                          ],
                        ))),
              ),
              Container(
                padding: EdgeInsets.only(top: height * 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    setCommonText('Change Password', AppColor.themeColor, 20.0,
                        FontWeight.bold, 1, TextAlign.center),
                    Container(
                      padding: EdgeInsets.all(15),
                      // height: 300,
                      // color: AppColor.red,
                      child: Column(
                        children: [
                          setCommonText(message, AppColor.black54, 16.0,
                              FontWeight.w400, 4, TextAlign.center)
                        ],
                      ),
                    ),
                    Container(
                        // height: 50,
                        padding: EdgeInsets.only(
                            left: 15, right: 25, top: 5, bottom: 5),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Password*'),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: AppColor.grey,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        // height: 50,
                        padding: EdgeInsets.only(
                            left: 15, right: 25, top: 5, bottom: 5),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextFormField(
                                obscureText: true,
                                controller: newPasswirdController,
                                maxLines: 2,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'New Password *'),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: AppColor.grey,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          if (_isValidate()) {
                            _changePassword();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: setCommonText('SUBMIT', AppColor.white, 16.0,
                                FontWeight.bold, 1, TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 25,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  BezierClipper(this.state);

  final int state;

  @override
  Path getClip(Size size) => _getInitialClip(size);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  Path _getInitialClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.90); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.75); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }
}
