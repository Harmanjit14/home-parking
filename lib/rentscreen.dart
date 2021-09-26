import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

class RentScreen extends StatefulWidget {
  const RentScreen({Key? key}) : super(key: key);

  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  CameraController? controller;
  @override
  void initState() {
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: Container(
        color: Colors.grey[900],
        height: size.height * 0.13,
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 10),
              ],
              borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: MaterialButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              height: double.maxFinite,
              onPressed: () async {},
              child: Text(
                "Scan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.021,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          CameraPreview(controller!),
        ],
      )),
    );
  }
}
