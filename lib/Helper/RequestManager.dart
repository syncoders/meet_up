import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Model/ModelCheckMeeting.dart';
import 'package:meet_up/Model/ModelCreateMeeting.dart';
import 'package:meet_up/Model/ModelDeleteItem.dart';
import 'package:meet_up/Model/ModelForgotPassword.dart';
import 'package:meet_up/Model/ModelLogin.dart';
import 'package:meet_up/Model/ModelMeetingList.dart';
import 'package:meet_up/Model/ModelProfile.dart';
import 'package:meet_up/Model/ModelRegistration.dart';

class Requestmanager {
//MARK: Do Login:
  Future<ResLogin> doLogin(dynamic param) async {
    http.Response response = await _apiRequest(APIS.login, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResLogin();
        userData.code = 0;
        userData.userData = UserData();
        userData.message = 'User data not found.';
        return userData;
      } else {
        return ResLogin.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Do Registration:
  Future<ResRegistration> doRegistration(dynamic param) async {
    http.Response response = await _apiRequest(APIS.register, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResRegistration();
        userData.code = 0;
        userData.message = result['error'];
        return userData;
      } else {
        return ResRegistration.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Forgot Password
  Future<ResForgotPassword> forgotPassword(dynamic param) async {
    http.Response response = await _apiRequest(APIS.forgotPassword, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 401) {
        final userData = ResForgotPassword();
        userData.code = 0;
        return userData;
      } else {
        return ResForgotPassword.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Create Meeting
  Future<ResCreateMeeting> createMeeting(dynamic param) async {
    http.Response response = await _apiRequest(APIS.createMeeting, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResCreateMeeting();
        userData.code = 0;
        return userData;
      } else {
        return ResCreateMeeting.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

//MARK: Check Meeting Availabele or not
  Future<ResProfile> getProfileData(String profileID) async {
    http.Response response = await _apiRequestWithGet(APIS.profile + profileID);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResProfile();
        userData.code = 0;
        userData.message = result['message'];
        return userData;
      } else {
        return ResProfile.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

//MARK: Check Meeting Availabele or not
  Future<ResCheckMeeting> checkMeeting(String meetingId) async {
    http.Response response =
        await _apiRequestWithGet(APIS.checkMeeting + meetingId);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResCheckMeeting();
        userData.code = 0;
        userData.message = result['message'];
        return userData;
      } else {
        return ResCheckMeeting.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Create Meeting
  Future<ResDeleteMeeting> changePassword(dynamic param) async {
    http.Response response = await _apiRequest(APIS.changePassword, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResDeleteMeeting();
        userData.code = 0;
        return userData;
      } else {
        return ResDeleteMeeting.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Create Meeting
  Future<ResCreateMeeting> updateMeeting(dynamic param) async {
    http.Response response = await _apiRequest(APIS.updateMeeting, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 501) {
        final userData = ResCreateMeeting();
        userData.code = 0;
        return userData;
      } else {
        return ResCreateMeeting.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Delete Meeting
  Future<ResDeleteMeeting> deleteMeeting(dynamic param) async {
    print('Delete meeting parameter $param');

    http.Response response = await _apiRequest(APIS.deleteMeeting, param);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 401) {
        final userData = ResDeleteMeeting();
        userData.code = 0;
        return userData;
      } else {
        return ResDeleteMeeting.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

  //MARK: Meeting List
  Future<ResMeetingList> meetingList(String userId) async {
    print('Meeting URL:${APIS.meetingList + userId}');
    http.Response response = await _apiRequestWithGet(
      APIS.meetingList + userId,
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("User Response:------>$result");
      final code = result['code'];
      if (code == 401) {
        final userData = ResMeetingList();
        userData.code = 0;
        userData.meetingData = [];
        return userData;
      } else {
        return ResMeetingList.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception("Fetch to failed user details");
    }
  }

//Common Method for request api
//POST WITH Header
  // Future<http.Response> _apiRequestWithHeader(
  //     String url, Map jsonMap, String header) async {
  //   var body = jsonEncode(jsonMap);
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "content-type": "application/json",
  //       "Token": header,
  //     },
  //     body: body,
  //   );
  //   print(response.body);
  //   return response;
  // }
}

//POST
Future<http.Response> _apiRequest(String url, Map jsonMap) async {
  var body = jsonEncode(jsonMap);
  var response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
    body: body,
  );
  print(response.body);
  return response;
}

//GET
Future<http.Response> _apiRequestWithGet(String url) async {
  var response = await http.get(url.toString());
  print(response.body);
  return response;
}

class ResChangePassword {
  String message;
  int code;
  ResChangePassword(this.message, this.code);
}
