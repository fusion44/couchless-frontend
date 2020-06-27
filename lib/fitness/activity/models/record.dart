import 'package:latlong/latlong.dart';

import '../../../common/utils.dart';
import 'heart_rate_zone_data.dart';

class Record {
  String id;
  String activityId;
  DateTime timestamp;
  LatLng position;
  num distance;
  num timeFromCourse;
  num heartRate;
  HRZone heartRateZone;
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
    timestamp = DateTime.parse(json['timestamp']);
    position = LatLng(
      ensureDouble(json['positionLat']),
      ensureDouble(json['positionLong']),
    );
    distance = json['distance'];
    timeFromCourse = json['timeFromCourse'];
    heartRate = json['heartRate'];
    heartRateZone = _getHeartRateZone(json['heartRate']);
    altitude = json['altitude'];
    speed = ensureDouble(json['speed']);
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

HRZone _getHeartRateZone(hr) {
  if (hr <= HRZoneLimits.zone1) {
    return HRZone.zone1;
  } else if (hr <= HRZoneLimits.zone2) {
    return HRZone.zone2;
  } else if (hr <= HRZoneLimits.zone3) {
    return HRZone.zone3;
  } else if (hr <= HRZoneLimits.zone4) {
    return HRZone.zone4;
  }
  return HRZone.zone5;
}
