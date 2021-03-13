import 'package:flutter/material.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/RequestManager.dart';
import 'package:meet_up/Screens/ChangePassword.dart';
import 'package:meet_up/Screens/LoginScreen.dart';
import 'package:meet_up/Socket/SharedManaged.dart';
import 'package:share/share.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var name = 'Guest User';
  var userName = 'Guest User';
  var email = 'guestuser@gmail.com';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _getuserData() async {
    showSnackbar('Loading...', _scaffoldKey);
    Requestmanager manager = Requestmanager();
    await manager
        .getProfileData('${SharedManager.shared.userId}')
        .then((value) async {
      hideSnackBar(_scaffoldKey);
      if (value.code == 200) {
        //save data to database for future us
        setState(() {
          userName = value.profileData[0].username;
          email = value.profileData[0].email;
        });
      } else {
        this.setState(() {});
        SharedManager.shared.showAlertDialog('Data not found', context);
      }
    });
  }

  _setProfileBanner() {
    return Container(
      height: 130,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: AppColor.red,
                    borderRadius: BorderRadius.circular(35)),
                child: Center(
                  child: setCommonText(
                      (userName.length > 0)
                          ? '${userName[0].toUpperCase()}'
                          : '',
                      AppColor.white,
                      35.0,
                      FontWeight.w800,
                      1,
                      TextAlign.start),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setCommonText('${this.userName}', AppColor.grey, 16.0,
                        FontWeight.w400, 2, TextAlign.start),
                    SizedBox(height: 5),
                    setCommonText('${this.email}', AppColor.black54, 14.0,
                        FontWeight.w400, 1, TextAlign.start),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _setLogutView() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
          child: InkWell(
            onTap: () async {
              //   Navigator.of(context)
              // .push(MaterialPageRoute(builder: (context) => LoginPage()));
              await SharedManager.shared.set(DefaultKeys.isLoggedIn, 'no');
              SharedManager.shared.isLogedIn = false;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      setCommonText('Logout', AppColor.black87, 15.0,
                          FontWeight.w500, 1, TextAlign.start),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColor.themeColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setChangePasswordView() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
          child: InkWell(
            onTap: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePassword()));
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      setCommonText('Change Password', AppColor.black87, 15.0,
                          FontWeight.w500, 1, TextAlign.start),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColor.themeColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setPersonalMeetingIdView() {
    return Container(
      height: 80,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
          child: InkWell(
            onTap: () {
              Share.share('Share personal meeting id:- ${this.userName}');
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      setCommonText('Personal Meeting ID:', AppColor.black87,
                          15.0, FontWeight.w400, 1, TextAlign.start),
                      SizedBox(height: 5),
                      setCommonText('${this.userName}', AppColor.black, 15.0,
                          FontWeight.w700, 2, TextAlign.start),
                    ],
                  ),
                ),
                Icon(
                  Icons.share,
                  size: 20,
                  color: AppColor.themeColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if ((SharedManager.shared.isLogedIn)) {
      Future.delayed(Duration(milliseconds: 300)).then((_) => _getuserData());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: setCommonAppBar('Profile', false, context, []),
      body: (SharedManager.shared.isLogedIn)
          ? Container(
              child: ListView(
              children: [
                _setProfileBanner(),
                SizedBox(
                  height: 15,
                ),
                _setPersonalMeetingIdView(),
                SizedBox(
                  height: 15,
                ),
                _setChangePasswordView(),
                SizedBox(
                  height: 15,
                ),
                _setLogutView(),
              ],
            ))
          : setLockedAccessWidgets(
              context,
              false,
              'You profile information will appear here once you are logged in',
              '0'),
    );
  }
}
