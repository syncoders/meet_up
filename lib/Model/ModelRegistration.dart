class ResRegistration {
  int code;
  String message;
  String error;

  ResRegistration({this.code, this.message, this.error});

  ResRegistration.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}
