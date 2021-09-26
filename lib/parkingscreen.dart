import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'exports.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key, required this.obj}) : super(key: key);
  final DocumentSnapshot obj;

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  GoogleMapController? _controller;
  final LatLng _center = LatLng(user.latitude, user.longitude);

  Marker? start;
  Marker? end;
  Set<Marker> _set = {};

  late PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBEsBxIntcFlIbg_tNCWvJ-MURS0ckImRk", // Google Maps API Key
      PointLatLng(northEastLatitude, northEastLongitude),
      PointLatLng(southWestLatitude, southWestLongitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(_center.latitude, _center.longitude),
          southwest: LatLng(destinationLatitude, destinationLongitude),
        ),
        100.0,
      ),
    );
  }

  @override
  void initState() {
    start = Marker(markerId: MarkerId("start"), position: _center);

    final GeoPoint _end = widget.obj.get("geo");
    final LatLng e = LatLng(_end.latitude, _end.longitude);

    end = Marker(markerId: MarkerId("end"), position: e);
    _set.add(start!);
    _set.add(end!);
    _createPolylines(
        _center.latitude, _center.longitude, e.latitude, e.longitude);

    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                    polylines: Set<Polyline>.of(polylines.values),
                    markers: _set,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(target: _center)),
              ),
              height: size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(blurRadius: 9, color: Colors.white)
                ],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
      )),
    );
  }
}
