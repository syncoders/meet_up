class ResProfile {
  int code;
  String message;
  List<ProfileData> profileData;
  String error;

  ResProfile({this.code, this.message, this.profileData, this.error});

  ResProfile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      profileData = new List<ProfileData>();
      json['data'].forEach((v) {
        profileData.add(new ProfileData.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.profileData != null) {
      data['data'] = this.profileData.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class ProfileData {
  int id;
  String username;
  String email;

  ProfileData({this.id, this.username, this.email});

  ProfileData.fromJson(Map<String, dynamic> json) {
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
