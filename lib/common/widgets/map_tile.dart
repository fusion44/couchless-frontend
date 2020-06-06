import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapTile extends StatefulWidget {
  final LatLng center;
  final LatLngBounds bounds;
  final List<LatLng> path;

  const MapTile({
    Key key,
    @required this.center,
    @required this.bounds,
    this.path = const [],
  }) : super(key: key);

  @override
  _MapTileState createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        bounds: widget.bounds,
        boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(32.0)),
        interactive: false,
      ),
      layers: [
        _getTileLayer(),
        PolylineLayerOptions(
          polylines: [
            Polyline(
              points: widget.path,
              strokeWidth: 4.0,
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  TileLayerOptions _getTileLayer() {
    return TileLayerOptions(
      tileProvider: NetworkTileProvider(),
      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      subdomains: ['a', 'b', 'c'],
    );
    // return TileLayerOptions(
    //   tileProvider: NetworkTileProvider(),
    //   urlTemplate: "https://api.tiles.mapbox.com/v4/"
    //       "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
    //   additionalOptions: {
    //     'accessToken':
    //         'pk.your_token',
    //     'id': 'mapbox.streets',
    //   },
    // );
  }
}
