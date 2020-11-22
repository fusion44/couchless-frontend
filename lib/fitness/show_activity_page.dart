import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/sport_utils.dart';
import '../common/widgets/widgets.dart';
import 'activity/models/activity.dart';
import 'activity/models/heart_rate_zone_data.dart';
import 'widgets/widgets.dart';

class ShowActivityPage extends StatefulWidget {
  final Activity activity;
  ShowActivityPage(this.activity);

  @override
  _ShowActivityPageState createState() => _ShowActivityPageState();
}

enum ChartType { heartRate, altitude, speed }

class _ShowActivityPageState extends State<ShowActivityPage> {
  Activity _a;
  LatLng _center;
  LatLngBounds _bounds;
  List<LatLng> _path;
  Map<ChartType, List<FlSpot>> _spots = {
    ChartType.heartRate: [],
    ChartType.altitude: [],
    ChartType.speed: [],
  };

  double _minHeartRate, _maxHeartRate, _heartRateInterval;
  double _minAltitude, _maxAltitude, _altitudeInterval;
  double _minSpeed, _maxSpeed, _speedInterval;
  double _minX, _maxX, _xInterval;

  List<bool> _toggleButtonState = [true, false, false];
  ChartType _chartType = ChartType.heartRate;

  @override
  void initState() {
    super.initState();
    _a = widget.activity;
    _center = LatLng((_a.boundaryNorth + _a.boundarySouth) / 2,
        (_a.boundaryEast + _a.boundaryWest) / 2);
    _bounds = LatLngBounds(
      LatLng(_a.boundarySouth, _a.boundaryWest),
      LatLng(_a.boundaryNorth, _a.boundaryEast),
    );
    _path = _a.records
        .map((e) => LatLng(e.position.latitude, e.position.longitude))
        .toList();

    _minHeartRate = _maxHeartRate = _a.records[0].heartRate.toDouble();
    _minAltitude = _maxAltitude = _a.records[0].altitude.toDouble();
    _minSpeed = _maxSpeed = _a.records[0].speed.toDouble();

    _a.records.forEach((rec) {
      var t = rec.timestamp.difference(_a.startTime).inMilliseconds.toDouble();

      var hr = rec.heartRate.toDouble();
      if (hr < _minHeartRate) _minHeartRate = hr;
      if (hr > _maxHeartRate) _maxHeartRate = hr;
      _spots[ChartType.heartRate].add(FlSpot(t, hr));

      var alt = rec.altitude.toDouble();
      if (alt < _minAltitude) _minAltitude = alt;
      if (alt > _maxAltitude) _maxAltitude = alt;
      _spots[ChartType.altitude].add(FlSpot(t, alt));

      var speed = rec.speed.toDouble() * 3.6;
      if (speed < _minSpeed) _minSpeed = speed;
      if (speed > _maxSpeed) _maxSpeed = speed;
      _spots[ChartType.speed].add(FlSpot(t, speed));
    });

    _minHeartRate -= 10;
    _maxHeartRate += 10;

    _minAltitude -= 10;
    _maxAltitude += 10;

    if (_minSpeed > 10) {
      _minSpeed -= 10;
    }
    _maxSpeed += 10;

    _heartRateInterval = (_maxHeartRate - _minHeartRate) / 2;
    _altitudeInterval = (_maxAltitude - _minAltitude) / 2;
    _speedInterval = (_maxSpeed - _minSpeed) / 2;

    _minX = 0;
    _maxX = _a.endTime.difference(_a.startTime).inMilliseconds.toDouble();
    _xInterval = _maxX / 4;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Activity')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                getIconForSport(_a.sportType),
                Container(width: 8),
                Expanded(
                  child: Text(
                    getNameForSport(_a.sportType),
                    style: theme.textTheme.headline4,
                  ),
                ),
                Tooltip(
                  message: _a.startTime.toString(),
                  child: Text(
                    timeago.format(_a.startTime),
                    style: theme.textTheme.headline6,
                  ),
                )
              ],
            ),
            Container(height: 8.0),
            Container(
              height: 300,
              child: MapTile(
                center: _center,
                bounds: _bounds,
                path: _path,
                interactive: true,
              ),
            ),
            Container(height: 8.0),
            _buildToggleButtons(),
            _buildHeartRateChart(theme),
            Container(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  _buildTrainingEffectChart(theme),
                  Container(width: 46),
                  HRZonesPieChart(_a),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ToggleButtons _buildToggleButtons() {
    return ToggleButtons(
      renderBorder: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: RaisedButton(
            child: Text('Heart Rate'),
            onPressed: _toggleButtonState[0]
                ? null
                : () {
                    if (_toggleButtonState[0]) return;
                    setState(() {
                      _toggleButtonState = [true, false, false];
                      _chartType = ChartType.heartRate;
                    });
                  },
          ),
        ),
        RaisedButton(
            child: Text('Altitude'),
            onPressed: _toggleButtonState[1]
                ? null
                : () {
                    if (_toggleButtonState[1]) return;
                    setState(() {
                      _toggleButtonState = [false, true, false];
                      _chartType = ChartType.altitude;
                    });
                  }),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RaisedButton(
              child: Text('Speed'),
              onPressed: _toggleButtonState[2]
                  ? null
                  : () {
                      if (_toggleButtonState[2]) return;
                      setState(() {
                        _toggleButtonState = [false, false, true];
                        _chartType = ChartType.speed;
                      });
                    }),
        ),
      ],
      isSelected: _toggleButtonState,
    );
  }

  Widget _buildTrainingEffectChart(ThemeData theme) {
    return ClipRect(
      clipper: GaugeChartClipper(),
      child: Container(
        height: 200,
        width: 200,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GaugeChart(
              value: _a.totalTrainingEffect,
              max: 5,
              mainColor: Colors.amber,
              secondaryColor: Colors.blueGrey,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  'Total Training Effect',
                  style: theme.textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 85.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _a.totalTrainingEffect.toString(),
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateChart(ThemeData theme) {
    return Container(
      height: 250.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LineChart(
              _getLineChartData(theme),
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _getLineChartHeader(theme),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLineChartHeader(ThemeData theme) {
    String text = 'HeartRate (bpm)';
    if (_chartType == ChartType.altitude) {
      text = 'Altitude (m)';
    } else if (_chartType == ChartType.speed) {
      text = 'Speed (km/h)';
    }

    return Text(
      text,
      style: theme.textTheme.headline5,
    );
  }

  LineChartData _getLineChartData(ThemeData theme) {
    try {
      switch (_chartType) {
        case ChartType.heartRate:
          return _getHeartRateData(theme);
          break;
        case ChartType.altitude:
          return _getAltitudeData(theme);
          break;
        case ChartType.speed:
          return _getSpeedData(theme);
          break;
        default:
          throw UnimplementedError();
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }
    return null;
  }

  LineChartData _getHeartRateData(ThemeData theme) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: getBottomTitles(theme),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => theme.textTheme.headline6,
          interval: _heartRateInterval,
          getTitles: (value) => value.toInt().toString(),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minHeartRate,
      maxY: _maxHeartRate,
      lineBarsData: [
        LineChartBarData(
          spots: _spots[ChartType.heartRate],
          shadow: Shadow(offset: Offset(2, 0)),
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          colors: HRZoneColors.asList(),
          colorStops: HRZoneLimits.asNormalizedList(),
          gradientFrom: const Offset(0, 1),
          gradientTo: const Offset(0, 0),
        )
      ],
    );
  }

  LineChartData _getAltitudeData(ThemeData theme) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: getBottomTitles(theme),
        leftTitles: SideTitles(
          interval: _altitudeInterval,
          showTitles: true,
          getTextStyles: (value) => theme.textTheme.headline6,
          getTitles: (value) => value.toInt().toString(),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minAltitude,
      maxY: _maxAltitude,
      lineBarsData: [
        LineChartBarData(
          spots: _spots[ChartType.altitude],
          colors: [Colors.green],
          shadow: Shadow(offset: Offset(2, 0)),
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
        )
      ],
    );
  }

  SideTitles getBottomTitles(ThemeData theme) {
    return SideTitles(
      showTitles: true,
      reservedSize: 25,
      getTextStyles: (value) => theme.textTheme.headline6,
      margin: 15,
      interval: _xInterval,
      getTitles: (value) => _getXTitle(value),
    );
  }

  LineChartData _getSpeedData(ThemeData theme) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: getBottomTitles(theme),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => theme.textTheme.headline6,
          interval: _speedInterval,
          getTitles: (value) => value.toInt().toString(),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minSpeed,
      maxY: _maxSpeed,
      lineBarsData: [
        LineChartBarData(
          spots: _spots[ChartType.speed],
          colors: [Colors.blueGrey],
          shadow: Shadow(offset: Offset(2, 0)),
          barWidth: 3,
          isCurved: false,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
        )
      ],
    );
  }

  String _getXTitle(double value) {
    var dur = Duration(milliseconds: value.toInt());
    return dur.toString().split('.').first.padLeft(8, "0");
  }
}

class GaugeChartClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 200, 170);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
