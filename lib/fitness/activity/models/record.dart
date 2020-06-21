import 'package:latlong/latlong.dart';

import '../../../common/utils.dart';

class Record {
  String id;
  String activityId;
  String timestamp;
  LatLng position;
  num distance;
  num timeFromCourse;
  num heartRate;
  num altitude;
  num speed;
  num power;
  num grade;
  num cadence;
  num fractionalCadence;
  num resistance;
  num cycleLength;
  num temperature;
  num accumulatedPower;

  Record({
    this.id,
    this.activityId,
    this.timestamp,
    this.position,
    this.distance,
    this.timeFromCourse,
    this.heartRate,
    this.altitude,
    this.speed,
    this.power,
    this.grade,
    this.cadence,
    this.fractionalCadence,
    this.resistance,
    this.cycleLength,
    this.temperature,
    this.accumulatedPower,
  });

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityId = json['activityId'];
    timestamp = json['timestamp'];
    position = LatLng(
      ensureDouble(json['positionLat']),
      ensureDouble(json['positionLong']),
    );
    distance = json['distance'];
    timeFromCourse = json['timeFromCourse'];
    heartRate = json['heartRate'];
    altitude = json['altitude'];
    speed = json['speed'];
    power = json['power'];
    grade = json['grade'];
    cadence = json['cadence'];
    fractionalCadence = json['fractionalCadence'];
    resistance = json['resistance'];
    cycleLength = json['cycleLength'];
    temperature = json['temperature'];
    accumulatedPower = json['accumulatedPower'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['activityId'] = this.activityId;
    data['timestamp'] = this.timestamp;
    data['positionLat'] = this.position.latitude;
    data['positionLong'] = this.position.longitude;
    data['distance'] = this.distance;
    data['timeFromCourse'] = this.timeFromCourse;
    data['heartRate'] = this.heartRate;
    data['altitude'] = this.altitude;
    data['speed'] = this.speed;
    data['power'] = this.power;
    data['grade'] = this.grade;
    data['cadence'] = this.cadence;
    data['fractionalCadence'] = this.fractionalCadence;
    data['resistance'] = this.resistance;
    data['cycleLength'] = this.cycleLength;
    data['temperature'] = this.temperature;
    data['accumulatedPower'] = this.accumulatedPower;
    return data;
  }
}
