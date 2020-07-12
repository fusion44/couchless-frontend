import 'package:flutter/material.dart';

import 'record.dart';

enum HRZone { zone1, zone2, zone3, zone4, zone5 }

class HRZoneColors {
  static final Color zone1 = Colors.grey;
  static final Color zone2 = Colors.blue[200];
  static final Color zone3 = Colors.lightGreen[200];
  static final Color zone4 = Colors.orange[200];
  static final Color zone5 = Colors.red[300];

  static List<Color> asList() => [zone1, zone2, zone3, zone4, zone5];
}

class HRZoneLimits {
  static final zone1 = 117;
  static final zone2 = 137;
  static final zone3 = 157;
  static final zone4 = 176;

  static List<double> asNormalizedList() => const [0.2, 0.3, 0.5, 0.6, 1];
}

class HRZoneData {
  final int zone1;
  final int zone2;
  final int zone3;
  final int zone4;
  final int zone5;
  final int numEntries;

  HRZoneData(
    this.zone1,
    this.zone2,
    this.zone3,
    this.zone4,
    this.zone5,
    this.numEntries,
  );

  static HRZoneData fromRecords(List<Record> records) {
    int z1 = 0, z2 = 0, z3 = 0, z4 = 0, z5 = 0;
    records.forEach((r) {
      if (r.heartRateZone == HRZone.zone1) {
        z1 += 1;
      } else if (r.heartRateZone == HRZone.zone2) {
        z2 += 1;
      } else if (r.heartRateZone == HRZone.zone3) {
        z3 += 1;
      } else if (r.heartRateZone == HRZone.zone4) {
        z4 += 1;
      } else {
        z5 += 1;
      }
    });
    return HRZoneData(
      z1,
      z2,
      z3,
      z4,
      z5,
      z1 + z2 + z3 + z4 + z5,
    );
  }

  @override
  String toString() {
    return 'z1: $zone1, z2: $zone2, z3: $zone3, z4: $zone4, z5: $zone5, total: $numEntries';
  }
}
