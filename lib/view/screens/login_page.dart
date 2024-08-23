import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validate(String val) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

    RegExp emailPattern = RegExp(pattern);

    return val.isNotEmpty && !emailPattern.hasMatch(val)
        ? "Enter valid email"
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chat App",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (val) => validate(val!),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Enter email..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => (val == "") ? "Enter password" : null,
                    decoration: InputDecoration(labelText: "Enter password..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: Text("Log In"),
                    color: Colors.blue,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        User? user = await FirebaseAuthHelper.firebaseAuthHelper
                            .userSingIn(
                          email: email,
                          password: password,
                          context: context,
                        );

                        if (user != null) {
                          FireStoreHelper.fireStoreHelper
                              .setUserData(user: user);

                          Navigator.of(context).pushReplacementNamed(
                              'home_page',
                              arguments: user);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login successfully"),
                              backgroundColor: Colors.tealAccent,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.g_mobiledata_sharp),
                    label: Text("GOOGLE"),
                    onPressed: () async {
                      User? user = await FirebaseAuthHelper.firebaseAuthHelper
                          .userGoogleSignIn(context: context);

                      UserModel userModel = UserModel(
                        uid: user!.uid,
                        userName: user.displayName as String,
                        userEmail: user.email as String,
                        userProfilePic: user.photoURL as String,
                      );

                      if (user != null) {
                        await FireStoreHelper.fireStoreHelper
                            .setUserData(user: user);
                        Navigator.of(context).pushReplacementNamed('home_page');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account ?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            CupertinoButton(
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('sing_up_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
