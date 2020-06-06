import 'package:lifelog/auth/models/user.dart';

import 'record.dart';

class Activity {
  String id;
  String comment;
  DateTime startTime;
  DateTime endTime;
  String sportType;
  double boundaryNorth;
  double boundarySouth;
  double boundaryEast;
  double boundaryWest;
  User user;
  List<Record> records;

  Activity({
    this.id,
    this.comment,
    this.startTime,
    this.endTime,
    this.sportType,
    this.boundaryNorth,
    this.boundarySouth,
    this.boundaryEast,
    this.boundaryWest,
    this.user,
    this.records,
  });

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    startTime = DateTime.parse(json['startTime']);
    endTime = DateTime.parse(json['endTime']);
    sportType = json['sportType'];
    boundaryNorth = json['boundaryNorth'];
    boundarySouth = json['boundarySouth'];
    boundaryEast = json['boundaryEast'];
    boundaryWest = json['boundaryWest'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['records'] != null) {
      records = <Record>[];
      json['records'].forEach(
        (v) {
          records.add(Record.fromJson(v));
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['sportType'] = sportType;
    data['boundaryNorth'] = boundaryNorth;
    data['boundarySouth'] = boundarySouth;
    data['boundaryEast'] = boundaryEast;
    data['boundaryWest'] = boundaryWest;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
