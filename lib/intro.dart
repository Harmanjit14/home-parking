import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'exports.dart';

class IntoScreen extends StatelessWidget {
  const IntoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  // color: Colors.green,
                  height: size.height * 0.4,
                  child: Image.asset("assets/logo.gif"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Text(
                    "Home Park",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.05,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    "yahan pe kuch bhi text likha hua hai jisko baad main araam se sort karenge abhi sirf dikhne main acha lag raha hai..",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: size.height * 0.02,
                        color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            // const SizedBox.expand(),
            Expanded(child: Container()),
            Container(
              color: Colors.black,
              height: size.height * 0.13,
              padding: const EdgeInsets.all(20),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 10),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Expanded(
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
                            onPressed: () {
                              Get.to(() => RegisterScreen());
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.021,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(10),
                            height: double.maxFinite,
                            onPressed: () {
                              Get.to(() => LoginScreen());
                            },
                            child: Text(
                              "SignIn",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.021,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
