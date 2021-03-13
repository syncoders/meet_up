import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Model/ModelMeetingList.dart';
import 'package:meet_up/Screens/TabBarScreen/TabBar.dart';
import 'package:meet_up/Socket/SharedManaged.dart';
import 'package:share/share.dart';
import '../HostMeetingScreen.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MeetingData> meetingList = [];

  _getMeetingList() async {
    this.meetingList = [];
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager
        .meetingList('${SharedManager.shared.userId}')
        .then((value) async {
      hideSnackBar(_scaffoldKey);
      if (value.code == 200) {
        //save data to database for future us
        setState(() {
          this.meetingList = value.meetingData;
        });
      } else {
        this.setState(() {});
        SharedManager.shared.showAlertDialog('Data not found', context);
      }
    });
  }

  _deleteMeeting(String meetingId) async {
    final param = {"meetingId": "$meetingId"};

    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager.deleteMeeting(param).then((value) {
      hideSnackBar(_scaffoldKey);
      if (value.code == 200) {
        _getMeetingList();
      } else {
        hideSnackBar(_scaffoldKey);
        SharedManager.shared
            .showAlertDialog('not able to delete meeting', context);
      }
    });
  }

  _showAlertForDelete(String meetingId) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        //Delete stuff here
        _deleteMeeting(meetingId);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("MeetUp"),
      content: Text("Are you sure you want to delete the meeting?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _setAlertWindowForJoinMeeting(String userName, String meetingId) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("JOIN"),
      onPressed: () {
        Navigator.of(context).pop();
        SharedManager.shared.meetingID = meetingId;
        SharedManager.shared.userName = userName;
        SharedManager.shared.currentIndex = 1;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabBarScreen()),
            (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("MeetUp"),
      content: Text("Are you sure you want to join the meeting?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if ((SharedManager.shared.isLogedIn)) {
      Future.delayed(Duration(milliseconds: 300))
          .then((_) => _getMeetingList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: setCommonAppBar('My Meetings', false, context, []),
      body: Container(
        child: (SharedManager.shared.isLogedIn)
            ? (this.meetingList.length > 0)
                ? ListView.builder(
                    itemCount: this.meetingList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 130,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            _setAlertWindowForJoinMeeting(
                                SharedManager.shared.userName,
                                this.meetingList[index].meetingId);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                      color: AppColor.grey[300],
                                      offset: Offset(0, 0))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        setCommonText(
                                            '${this.meetingList[index].title}',
                                            AppColor.black87,
                                            15.0,
                                            FontWeight.w500,
                                            1,
                                            TextAlign.start),
                                        SizedBox(height: 5),
                                        setCommonText(
                                            '${this.meetingList[index].description}',
                                            AppColor.grey,
                                            13.0,
                                            FontWeight.w400,
                                            2,
                                            TextAlign.start),
                                        SizedBox(height: 5),
                                        setCommonText(
                                            '${this.meetingList[index].meetingId}',
                                            AppColor.black54,
                                            13.0,
                                            FontWeight.w400,
                                            1,
                                            TextAlign.start),
                                        SizedBox(height: 5),
                                        setCommonText(
                                            '${this.meetingList[index].inviteEmail}',
                                            AppColor.black54,
                                            13.0,
                                            FontWeight.w400,
                                            1,
                                            TextAlign.start),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HostMeetingScreen(
                                                        isEdit: true,
                                                        title: this
                                                            .meetingList[index]
                                                            .title,
                                                        email: this
                                                            .meetingList[index]
                                                            .inviteEmail,
                                                        description: this
                                                            .meetingList[index]
                                                            .description,
                                                        id: this
                                                            .meetingList[index]
                                                            .id
                                                            .toString(),
                                                        meetingId: this
                                                            .meetingList[index]
                                                            .meetingId,
                                                      )));
                                        },
                                        child: Icon(Icons.edit,
                                            size: 18,
                                            color: AppColor.themeColor),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Share.share(
                                              'use this meeting id to join the meeting:${this.meetingList[index].meetingId}');
                                        },
                                        child: Icon(Icons.share,
                                            size: 18,
                                            color: AppColor.themeColor),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            _showAlertForDelete(this
                                                .meetingList[index]
                                                .id
                                                .toString());
                                          },
                                          child: Icon(Icons.delete,
                                              size: 18, color: AppColor.red))
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('Assets/Images/envelope.png'),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(height: 10),
                        new Padding(
                          padding: new EdgeInsets.only(left: 35, right: 35),
                          child: new Text(
                            'Your meetings will appear here!',
                            style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontFamily: SharedManager.shared.fontFamilyName,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
            : setLockedAccessWidgets(context, false,
                'Your meetings will appear here once you are logged in', '1'),
      ),
    );
  }
}
