import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController;

  @override
  void initState() {
    super.initState();

    mapController = MapController();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlutterMap(
      options: MapOptions(
        center: Provider.of<GeneralStore>(context, listen: false).mapPos,
        zoom: Provider.of<GeneralStore>(context, listen: false).mapZoom,
        onPositionChanged: (mapPosition, boolValue) {
          Provider.of<GeneralStore>(context, listen: false).mapPos =
              mapPosition.center;
          Provider.of<GeneralStore>(context, listen: false).mapZoom =
              mapPosition.zoom;
        },
      ),
      mapController: mapController,
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            // Marker(
            //   width: 80.0,
            //   height: 80.0,
            //   point: LatLng(51.5, -0.09),
            //   builder: (ctx) => Container(
            //     child: FlutterLogo(),
            //   ),
            // ),
          ],
        ),
      ],
    ));
  }
}
