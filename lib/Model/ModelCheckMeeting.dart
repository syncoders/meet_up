class ResCheckMeeting {
  int code;
  String message;
  List<MettingData> meetingData;
  String error;

  ResCheckMeeting({this.code, this.message, this.meetingData, this.error});

  ResCheckMeeting.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      meetingData = new List<MettingData>();
      json['data'].forEach((v) {
        meetingData.add(new MettingData.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.meetingData != null) {
      data['data'] = this.meetingData.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class MettingData {
  int id;
  int userId;
  String meetingId;
  String title;
  String description;
  String inviteEmail;

  MettingData(
      {this.id,
      this.userId,
      this.meetingId,
      this.title,
      this.description,
      this.inviteEmail});

  MettingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    meetingId = json['meeting_id'];
    title = json['title'];
    description = json['description'];
    inviteEmail = json['invite_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['meeting_id'] = this.meetingId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['invite_email'] = this.inviteEmail;
    return data;
  }
}
