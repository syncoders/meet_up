import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Screens/TabBarScreen/TabBar.dart';
import 'package:meet_up/Socket/SharedManaged.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var message = 'Please enter required credentials for signup';
  int state = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();

  bool _isValidate() {
    if (this.userName.text == "") {
      SharedManager.shared.showAlertDialog('Enter username first', context);
      return false;
    } else if (this.email.text == "") {
      SharedManager.shared.showAlertDialog('Enter email address', context);
      return false;
    } else if (password.text == '') {
      SharedManager.shared.showAlertDialog('Enter password', context);
      return false;
    }
    return true;
  }

  _doRegistration() async {
    final param = {
      "email": "${this.email.text}",
      "password": "${this.password.text}",
      "username": "${this.userName.text}",
    };
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.doRegistration(param).then((value) {
      hideSnackBar(_scaffoldKey);
      if (value.code == 200) {
        //save data to database for future use
        SharedManager.shared.currentIndex = 1;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TabBarScreen()));
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
                    setCommonText('Signup', AppColor.themeColor, 25.0,
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
                                controller: userName,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Username'),
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
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          if (_isValidate()) {
                            _doRegistration();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: setCommonText('Signup', AppColor.white, 16.0,
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
                              Navigator.of(context).pop();
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
                              'Already Have an Account?',
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
                              Navigator.of(context).pop();
                            },
                            child: setCommonText('Signin', AppColor.themeColor,
                                15.0, FontWeight.w600, 1, TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8)
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
                    }),
              )
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
