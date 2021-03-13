import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Socket/SharedManaged.dart';

import 'TabBarScreen/TabBar.dart';

class HostMeetingScreen extends StatefulWidget {
  final bool isEdit;
  final String title;
  final String description;
  final String email;
  final String id;
  final String meetingId;

  HostMeetingScreen({
    this.isEdit,
    this.title,
    this.description,
    this.email,
    this.id,
    this.meetingId,
  });
  @override
  _HostMeetingScreenState createState() => _HostMeetingScreenState();
}

class _HostMeetingScreenState extends State<HostMeetingScreen> {
  var message = 'To host an online meeting, enter the required data here.';
  int state = 1;

  TextEditingController titleController = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController emailInvite = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isValidate() {
    if (this.titleController.text == '') {
      SharedManager.shared.showAlertDialog('Please enter the title', context);
      return false;
    } else if (this.description.text == '') {
      SharedManager.shared
          .showAlertDialog('Please enter the short discriptions', context);
      return false;
    }
    if (this.emailInvite.text == '') {
      SharedManager.shared.showAlertDialog(
          'Please enter email which you want to invite', context);
      return false;
    }
    return true;
  }

  _hostMetting() async {
    final param = {
      "title": "${this.titleController.text}",
      "description": "${this.description.text}",
      "email": "${this.emailInvite.text}",
      "userId": SharedManager.shared.userId,
      "username": SharedManager.shared.userName
    };
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.createMeeting(param).then((value) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if (value.code == 200) {
        SharedManager.shared.currentIndex = 0;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TabBarScreen()));
        SharedManager.shared
            .showAlertDialog('Meeting created successfully!', context);
      } else {
        SharedManager.shared
            .showAlertDialog('Failed to create meeting', context);
      }
    });
  }

  _updateMeeting() async {
    // final param = {
    //   "title": "${this.titleController.text}",
    //   "description": "${this.description.text}",
    //   "email": "${this.emailInvite.text}",
    //   "userId": SharedManager.shared.userId,
    //   "username": SharedManager.shared.userName
    // };

    final param = {
      "id": "${this.widget.id}",
      "title": "${this.titleController.text}",
      "email": "${this.emailInvite.text}",
      "description": "${this.description.text}",
      "username": SharedManager.shared.userName,
      "meetingId": "${this.widget.meetingId}"
    };
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.updateMeeting(param).then((value) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if (value.code == 200) {
        SharedManager.shared.currentIndex = 0;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TabBarScreen()));
        SharedManager.shared
            .showAlertDialog('Meeting update successfully!', context);
      } else {
        SharedManager.shared
            .showAlertDialog('Failed to create meeting', context);
      }
    });
  }

  _setData() {
    this.titleController.text = this.widget.title;
    this.description.text = this.widget.description;
    this.emailInvite.text = this.widget.email;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.isEdit) {
      _setData();
    }
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
                    setCommonText('Host Meeting', AppColor.themeColor, 20.0,
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
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Title*'),
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
                                controller: description,
                                maxLines: 2,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Description'),
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
                                controller: emailInvite,
                                maxLines: 2,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter email address to invite'),
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
                            if (this.widget.isEdit) {
                              _updateMeeting();
                            } else {
                              _hostMetting();
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: setCommonText(
                                (this.widget.isEdit) ? 'UPDATE' : 'SAVE',
                                AppColor.white,
                                16.0,
                                FontWeight.bold,
                                1,
                                TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
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
