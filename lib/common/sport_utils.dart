import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

String getNameForSport(String sport) {
  switch (sport) {
    case "hiking":
      return 'Hiking';
    case "running":
      return 'Running';
    case "cycling":
      return 'Cycling';
    case "training":
      return 'Training';
    case "generic":
      return 'Generic Sport';
    default:
      return 'Unsupported Sport: $sport';
  }
}

Widget getIconForSport(String sport) {
  switch (sport) {
    case "hiking":
      return Tooltip(
        message: 'Hiking',
        child: Icon(Foundation.mountains),
      );
    case "running":
      return Tooltip(
        message: 'Running',
        child: Icon(FontAwesome5Solid.running),
      );
    case "cycling":
      return Tooltip(
        message: 'Cycling',
        child: Icon(FontAwesome5Solid.bicycle),
      );
    case "training":
      return Tooltip(
        message: 'Training',
        child: Icon(FontAwesome5Solid.dumbbell),
      );
    case "generic":
      return Tooltip(
        message: 'Generic Sport',
        child: Icon(MaterialCommunityIcons.lock_question),
      );
    default:
      return Tooltip(
        message: 'Unsupported Sport: $sport',
        child: Icon(FontAwesome5Solid.question),
      );
  }
}