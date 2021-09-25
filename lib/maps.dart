
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  final LatLng _center = const LatLng(30.356743, 76.363662);
  Marker? marker;
  Set<Marker> s = {};
  @override
  void initState() {
    marker = Marker(
      markerId: const MarkerId("Home"),
      position: const LatLng(30.356743, 76.363662),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
    );
    // s = {marker!};
    s.add(marker!);
    // _controller!.showMarkerInfoWindow(MarkerId("Home"));
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Maps Sample App'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: s,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16,
        ),
      ),
    );
  }
}
