import '../../../auth/models/user.dart';
import '../../../common/utils.dart';
import 'record.dart';

class Activity {
  String id;
  String createdAt;
  DateTime startTime;
  DateTime endTime;
  String comment;
  String sportType;
  double boundaryNorth;
  double boundarySouth;
  double boundaryEast;
  double boundaryWest;
  num timePaused;
  num avgPace;
  num avgSpeed;
  num avgCadence;
  num avgFractionalCadence;
  num maxCadence;
  num maxSpeed;
  num totalDistance;
  num totalAscent;
  num totalDescent;
  num maxAltitude;
  num avgHeartRate;
  num maxHeartRate;
  num totalTrainingEffect;
  User user;
  List<Record> records;

  Activity({
    this.id,
    this.createdAt,
    this.startTime,
    this.endTime,
    this.comment,
    this.sportType,
    this.boundaryNorth,
    this.boundarySouth,
    this.boundaryEast,
    this.boundaryWest,
    this.timePaused,
    this.avgPace,
    this.avgSpeed,
    this.avgCadence,
    this.avgFractionalCadence,
    this.maxCadence,
    this.maxSpeed,
    this.totalDistance,
    this.totalAscent,
    this.totalDescent,
    this.maxAltitude,
    this.avgHeartRate,
    this.maxHeartRate,
    this.totalTrainingEffect,
    this.user,
    this.records,
  });

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    startTime = DateTime.parse(json['startTime']);
    endTime = DateTime.parse(json['endTime']);
    comment = json['comment'];
    sportType = json['sportType'];
    boundaryNorth = ensureDouble(json['boundaryNorth']);
    boundarySouth = ensureDouble(json['boundarySouth']);
    boundaryEast = ensureDouble(json['boundaryEast']);
    boundaryWest = ensureDouble(json['boundaryWest']);
    timePaused = json['timePaused'];
    avgPace = json['avgPace'];
    avgSpeed = json['avgSpeed'];
    avgCadence = json['avgCadence'];
    avgFractionalCadence = json['avgFractionalCadence'];
    maxCadence = json['maxCadence'];
    maxSpeed = json['maxSpeed'];
    totalDistance = json['totalDistance'];
    totalAscent = json['totalAscent'];
    totalDescent = json['totalDescent'];
    maxAltitude = json['maxAltitude'];
    avgHeartRate = json['avgHeartRate'];
    maxHeartRate = json['maxHeartRate'];
    totalTrainingEffect = json['totalTrainingEffect'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['records'] != null) {
      records = new List<Record>();
      json['records'].forEach((v) {
        records.add(Record.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['comment'] = this.comment;
    data['sportType'] = this.sportType;
    data['boundaryNorth'] = this.boundaryNorth;
    data['boundarySouth'] = this.boundarySouth;
    data['boundaryEast'] = this.boundaryEast;
    data['boundaryWest'] = this.boundaryWest;
    data['timePaused'] = this.timePaused;
    data['avgPace'] = this.avgPace;
    data['avgSpeed'] = this.avgSpeed;
    data['avgCadence'] = this.avgCadence;
    data['avgFractionalCadence'] = this.avgFractionalCadence;
    data['maxCadence'] = this.maxCadence;
    data['maxSpeed'] = this.maxSpeed;
    data['totalDistance'] = this.totalDistance;
    data['totalAscent'] = this.totalAscent;
    data['totalDescent'] = this.totalDescent;
    data['maxAltitude'] = this.maxAltitude;
    data['avgHeartRate'] = this.avgHeartRate;
    data['maxHeartRate'] = this.maxHeartRate;
    data['totalTrainingEffect'] = this.totalTrainingEffect;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
