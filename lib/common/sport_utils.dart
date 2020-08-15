import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

Color getColorForSport(String sport) {
  switch (sport) {
    case 'walking':
      return Colors.green[100];
    case "hiking":
      return Colors.green[300];
    case "running":
      return Colors.green[500];
    case "cycling":
      return Colors.deepOrange[400];
    case "training":
      return Colors.blue[600];
    case "alpine_skiing":
      return Colors.white;
    case "generic":
      return Colors.amber[300];
    default:
      print('Unsupported Sport: $sport');
      return Colors.black;
  }
}

String getNameForSport(String sport) {
  switch (sport) {
    case "hiking":
      return 'Hiking';
    case 'walking':
      return 'Walking';
    case "running":
      return 'Running';
    case "cycling":
      return 'Cycling';
    case "training":
      return 'Training';
    case "alpine_skiing":
      return 'Alpine Skiing';
    case "generic":
      return 'Generic Sport';
    default:
      return 'Unsupported Sport: $sport';
  }
}

Widget getIconForSport(String sport) {
  switch (sport) {
    case 'walking':
      return Tooltip(
        message: 'Walking',
        child: Icon(MaterialCommunityIcons.walk),
      );
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
    case "alpine_skiing":
      return Tooltip(
        message: 'Skiing',
        child: Icon(FontAwesome5Solid.skiing),
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
