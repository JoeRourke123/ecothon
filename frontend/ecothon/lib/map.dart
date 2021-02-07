import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:http/http.dart';
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

  Future<Response> _getLocations() async {
    http.Response res =
        await http.get('https://ecothon.space/api/posts/all-points', headers: {
      "Authorization":
          "Bearer " + Provider.of<GeneralStore>(context, listen: false).token
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GeneralStore>(context, listen: false).markers.isEmpty) {
      var futureLocations = _getLocations();
      futureLocations.then((response) {
        List<Marker> _markers = new List<Marker>();

        var decoded =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        for (Map<String, dynamic> i in decoded) {
          _markers.add(Marker(
            point: new LatLng(i["coordinates"][1], i["coordinates"][0]),
            anchorPos: AnchorPos.align(AnchorAlign.top),
            builder: (ctx) => Container(
              child: new Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitHeight,
                width: 40,
              ),
            ),
          ));
        }

        Provider.of<GeneralStore>(context, listen: false).markers = _markers;

        setState(() {});
      });
    }

    List<double> geo = Provider.of<GeneralStore>(context, listen: false).coords;

    return Container(
        child: FlutterMap(
      options: MapOptions(
        center: Provider.of<GeneralStore>(context, listen: false).mapPos ??
            LatLng(geo[1], geo[0]),
        zoom: Provider.of<GeneralStore>(context, listen: false).mapZoom ?? 15,
        minZoom: 0,
        maxZoom: 18,
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
          markers: Provider.of<GeneralStore>(context, listen: false).markers ??
              <Marker>[],
        ),
      ],
    ));
  }
}
