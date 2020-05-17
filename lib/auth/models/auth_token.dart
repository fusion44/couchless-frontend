class AuthToken {
  String accessToken;
  String expiredAt;

  AuthToken({this.accessToken, this.expiredAt});

  AuthToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['expiredAt'] = this.expiredAt;
    return data;
  }
}
