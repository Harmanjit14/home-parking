import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exports.dart';

class LoginButton extends GetxController {
  RxBool loading = false.obs;
}

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _key = GlobalKey<FormState>();
  final LoginButton _obj = Get.put(LoginButton());

  void login() {
    if (_obj.loading.value) return;
    _obj.loading.value = true;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then((value) {
      _obj.loading.value = false;
      Get.offAll(() => const MapScreen());
    }).catchError((e) {
      Get.snackbar("Error", e.message,
          //  "Unable to login, Please try again later..",
          icon: const Icon(Icons.error));
      _obj.loading.value = false;
      
    });
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
            child: Obx(
              () => MaterialButton(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                height: double.maxFinite,
                onPressed: () async {
                  (_key.currentState!.validate())
                      ? login()
                      : Timer(const Duration(seconds: 2), () {
                          _key.currentState!.reset();
                        });
                },
                child: (_obj.loading.value)
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.021,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.bottomLeft,
                height: size.height * 0.07,
                child: IconButton(
                    onPressed: () {
                      Get.off(() => const IntoScreen());
                    },
                    icon: Icon(Icons.navigate_before,
                        color: Colors.grey[500], size: size.height * 0.037)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Text(
                "Lets Sign you in.",
                // textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.044,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Text(
                "Welcome Back.\nYou've been missed!",
                // textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: size.height * 0.032,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty || !text.isEmail) {
                            return 'Enter Valid Email!';
                          }
                          return null;
                        },
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            // label: Text("Email"),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            hintText: "abcd@gmail.com",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )
                            // prefixIcon: Icon(Icons.email)
                            ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                        controller: _password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                            // label: Text("Email"),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.grey,
                            ),
                            hintText: "**********",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )
                            // prefixIcon: Icon(Icons.email)
                            ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
