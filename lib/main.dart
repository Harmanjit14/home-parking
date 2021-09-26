import 'package:after_layout/after_layout.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Parking',
      theme: ThemeData(
        brightness: Brightness.dark,
        splashColor: Colors.grey,
        primarySwatch: Colors.grey,
      ),
      home: authChanges(),
    );
  }
}

Widget authChanges() {
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        return const AuthChecker();
      } else {
        return const IntoScreen();
      }
    },
  );
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> with AfterLayoutMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 15),
            Text("Loading Please Wait...")
          ],
        ),
      )),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get()
        .then((value) {
      user.name = value.get("name");
      user.latitude = value.get("location")["latitude"];
      user.longitude = value.get("location")["longitude"];
      print(value);
      Get.offAll(() => MapScreen());
    }).catchError((e) {
      print(e);
      Get.offAll(() => const IntoScreen());
    });
  }
}
