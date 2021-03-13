class ResMeetingList {
  int code;
  String message;
  List<MeetingData> meetingData;
  String error;

  ResMeetingList({this.code, this.message, this.meetingData, this.error});

  ResMeetingList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      meetingData = new List<MeetingData>();
      json['data'].forEach((v) {
        meetingData.add(new MeetingData.fromJson(v));
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

class MeetingData {
  int id;
  int userId;
  String meetingId;
  String title;
  String description;
  String inviteEmail;

  MeetingData(
      {this.id,
      this.userId,
      this.meetingId,
      this.title,
      this.description,
      this.inviteEmail});

  MeetingData.fromJson(Map<String, dynamic> json) {
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
