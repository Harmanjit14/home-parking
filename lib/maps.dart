import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_parking/exports.dart';

class MapMarkers extends GetxController {
  // ignore: prefer_final_fields
  RxSet<Marker> _set = <Marker>{}.obs;
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final MapMarkers _obj = Get.put(MapMarkers());

  final LatLng _center = LatLng(user.latitude, user.longitude);
  Marker? marker;

  @override
  void initState() {
    marker = Marker(
      markerId: MarkerId("Home"),
      position: _center,
      icon: BitmapDescriptor.defaultMarker,
    );
    _obj._set.value.add(marker!);
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => GoogleMap(
                mapType: MapType.normal,
                markers: _obj._set.value,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Parking Areas Near Me",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [Shadow(color: Colors.grey)]),
                  ),
                  Container(
                    height: size.height * 0.25,
                    color: Colors.transparent,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 100,
                                  child: Image.asset("assets/car.png")),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.timelapse,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        "9-10",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(20),
                          height: double.maxFinite,
                          width: 230,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.black, blurRadius: 7)
                              ],
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: double.maxFinite,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: double.maxFinite,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
