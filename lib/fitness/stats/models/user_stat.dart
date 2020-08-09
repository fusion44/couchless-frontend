class UserStat {
  String period;
  int total;
  String sportType;

  UserStat({this.period, this.total, this.sportType});

  UserStat.fromJson(Map<String, dynamic> json) {
    period = json['period'];
    total = json['total'];
    sportType = json['sportType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period'] = this.period;
    data['total'] = this.total;
    data['sportType'] = this.sportType;
    return data;
  }
}
