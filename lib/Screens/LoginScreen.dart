import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Model/ModelLogin.dart';
import 'package:meet_up/Screens/ForgotPassword.dart';
import 'package:meet_up/Screens/JoinMeeting.dart';
import 'package:meet_up/Screens/SignupPage.dart';
import 'package:meet_up/Socket/SharedManaged.dart';

import 'TabBarScreen/TabBar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var message = 'Please enter your login credentials for host the meeting';
  int state = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isValidate() {
    if (this.email.text == "") {
      SharedManager.shared.showAlertDialog('Enter email address', context);
      return false;
    } else if (password.text == '') {
      SharedManager.shared.showAlertDialog('Enter password', context);
      return false;
    }
    return true;
  }

  _doLogin() async {
    final param = {
      "email": "${this.email.text}",
      "password": "${this.password.text}",
    };
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.doLogin(param).then((value) async {
      hideSnackBar(_scaffoldKey);
      if (value.code == 200) {
        //save data to database for future use
        UserData customer = value.userData;

        await SharedManager.shared.set(DefaultKeys.isLoggedIn, 'yes');
        SharedManager.shared.isLogedIn = true;
        SharedManager.shared.userName = '${customer.username}';

        await SharedManager.shared
            .set(DefaultKeys.userName, '${customer.username}');
        await SharedManager.shared
            .set(DefaultKeys.userEmail, '${customer.email}');
        await SharedManager.shared
            .set(DefaultKeys.userId, '${customer.id.toString()}');

        SharedManager.shared.currentIndex = 1;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabBarScreen()),
            (Route<dynamic> route) => false);
      } else {
        SharedManager.shared.showAlertDialog('${value.message}', context);
      }
    });
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
                      height: 10,
                    ),
                    setCommonText('Login', AppColor.themeColor, 25.0,
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
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email Address'),
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
                                controller: password,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password'),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: AppColor.grey,
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                            },
                            child: setCommonText(
                                'Forgot Password?',
                                AppColor.themeColor,
                                15.0,
                                FontWeight.w600,
                                1,
                                TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          if (_isValidate()) {
                            _doLogin();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: setCommonText('Login', AppColor.white, 16.0,
                                FontWeight.bold, 1, TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => JoinMeeting()));
                            },
                            child: setCommonText(
                                'Join Meeting?',
                                AppColor.themeColor,
                                15.0,
                                FontWeight.w600,
                                1,
                                TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setCommonText(
                              'Don\'t Have an Account?',
                              AppColor.black87,
                              15.0,
                              FontWeight.w600,
                              1,
                              TextAlign.center),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                            },
                            child: setCommonText('Signup', AppColor.themeColor,
                                15.0, FontWeight.w600, 1, TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8)
                  ],
                ),
              ),
              // Positioned(
              //   top: 25,
              //   child: IconButton(
              //       icon: Icon(
              //         Icons.arrow_back_ios,
              //         color: AppColor.white,
              //       ),
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       }),
              // )
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
