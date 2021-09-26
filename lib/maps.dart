import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
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

  final geo = Geoflutterfire();
  GeoFirePoint? center;

  Widget container(DocumentSnapshot obj, int distance) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 65,
                  child: Image.asset("assets/${obj.get("type")}.png")),
              const SizedBox(
                height: 5,
              ),
              Text(
                obj.get("type").toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              )
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timelapse,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    obj.get("time").toString(),
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.car_rental,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Space for ${obj.get("space")}",
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.alt_route,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    "$distance km",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
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
          boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 7)],
          borderRadius: BorderRadius.circular(25)),
    );
  }

  @override
  void initState() {
    marker = Marker(
      markerId: MarkerId("Home"),
      position: _center,
      icon: BitmapDescriptor.defaultMarker,
    );
    _obj._set.value.add(marker!);
    center =
        geo.point(latitude: _center.latitude, longitude: _center.longitude);
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.commute,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Parking Areas Near Me",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            shadows: [Shadow(color: Colors.grey)]),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                      // stream: geo
                      // .collection(
                      //     collectionRef: FirebaseFirestore.instance
                      //         .collection("parking"))
                      // .within(center: center!, radius: 350, field: "geo"),
                      stream: FirebaseFirestore.instance
                          .collection("parking")
                          .snapshots(),
                      builder: (context, snapshot) {
                        //  print(snapshot.data!.docs[0]);
                        if (snapshot.isBlank!) {
                          return const Text("No data");
                        }
                        return Container(
                          height: size.height * 0.20,
                          color: Colors.transparent,
                          child: ListView.builder(
                            itemCount: (snapshot.data!.size <= 15)
                                ? snapshot.data!.size
                                : 15,
                            itemBuilder: (context, index) {
                              GeoPoint d =
                                  snapshot.data!.docs[index].get("geo");

                              Marker temp = Marker(
                                markerId: MarkerId(
                                    snapshot.data!.docs[index].get("type")),
                                position: LatLng(d.latitude, d.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue),
                              );
                              _obj._set.value.add(temp);

                              double distance = Geolocator.distanceBetween(
                                      d.latitude,
                                      d.longitude,
                                      center!.latitude,
                                      center!.longitude) /
                                  10000;
                              return container(
                                  snapshot.data!.docs[index], distance.floor());
                            },
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                          ),
                        );
                      }),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                    height: size.height * 0.12,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Home-Park",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              shadows: [Shadow(blurRadius: 5)],
                              fontWeight: FontWeight.bold),
                        ),
                        const Expanded(child: SizedBox()),
                        FloatingActionButton(
                            backgroundColor: Colors.white,
                            elevation: 1,
                            child: const Icon(
                              Icons.account_circle,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {}),
                        // IconButton(
                        //   splashColor: Colors.white,
                        //   splashRadius: 60,
                        //   onPressed: () {},
                        //   icon: const Icon(Icons.account_circle),
                        //   color: Colors.black,
                        //   iconSize: 45,
                        // )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
