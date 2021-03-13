import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Screens/HostMeetingScreen.dart';
import 'package:meet_up/Screens/LoginScreen.dart';
import 'package:meet_up/Socket/CallSample.dart';
import 'package:meet_up/Socket/SharedManaged.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinMeeting extends StatefulWidget {
  JoinMeeting({Key key}) : super(key: key);

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  var message =
      'To join an online meeting, enter the meeting ID provided by the organiser.';
  int state = 1;

  TextEditingController meetingId = TextEditingController();
  TextEditingController userName = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _setUpUser() async {
    final prefs = await SharedPreferences.getInstance();
    SharedManager.shared.userId =
        prefs.getString('${DefaultKeys.userId}') ?? '';
    SharedManager.shared.userName =
        prefs.getString('${DefaultKeys.userName}') ?? '';
    var status = prefs.getString('${DefaultKeys.isLoggedIn}') ?? '';
    if (status == 'yes') {
      SharedManager.shared.isLogedIn = true;
    }
  }

  bool _isValidate() {
    if (meetingId.text == '') {
      SharedManager.shared.showAlertDialog('Please enter meeting id', context);
      return false;
    } else if (userName.text == '') {
      SharedManager.shared.showAlertDialog('Please enter username', context);
      return false;
    }
    return true;
  }

  _joinMeeting() async {
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.checkMeeting(meetingId.text.toLowerCase()).then((value) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if (value.code == 200) {
        SharedManager.shared.meetingID = meetingId.text.toLowerCase();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CallSample()));
      } else {
        SharedManager.shared.showAlertDialog('${value.message}', context);
      }
    });
  }

  @override
  void initState() {
    _setUpUser();
    // TODO: implement initState
    super.initState();
    this.meetingId.text = SharedManager.shared.meetingID;
    this.userName.text = SharedManager.shared.userName;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.35;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                    setCommonText('Join Meeting', AppColor.themeColor, 20.0,
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
                                controller: meetingId,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Meeting ID or UserID'),
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
                                controller: userName,
                                keyboardType: TextInputType.text,
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
                      height: 35,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          if (_isValidate()) {
                            _joinMeeting();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: setCommonText('JOIN', AppColor.white, 16.0,
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
                              if (SharedManager.shared.isLogedIn) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HostMeetingScreen(
                                          isEdit: false,
                                        )));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              }
                            },
                            child: setCommonText(
                                'Host Meeting?',
                                AppColor.themeColor,
                                15.0,
                                FontWeight.w600,
                                1,
                                TextAlign.center),
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
