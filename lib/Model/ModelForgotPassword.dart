class ResForgotPassword {
  int code;
  String message;
  String data;
  String error;

  ResForgotPassword({this.code, this.message, this.data, this.error});

  ResForgotPassword.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    data['error'] = this.error;
    return data;
  }
}
