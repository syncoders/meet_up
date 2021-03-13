class ResLogin {
  int code;
  String message;
  UserData userData;
  String error;

  ResLogin({this.code, this.message, this.userData, this.error});

  ResLogin.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    userData =
        json['data'] != null ? new UserData.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.userData != null) {
      data['data'] = this.userData.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class UserData {
  int id;
  String username;
  String email;

  UserData({this.id, this.username, this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}
