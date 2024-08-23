import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController CpasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                    validator: (val) => (val == "") ? "Enter email" : null,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Enter email..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) => (val == "") ? "Enter password" : null,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(labelText: "Enter password..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: CpasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) =>
                        (val == "") ? "Enter conform password" : null,
                    decoration:
                        InputDecoration(labelText: "Enter conform password..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: Text("Sing Up"),
                    color: Colors.blue,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String Cpassword = CpasswordController.text.trim();

                        if (password != Cpassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password are not match"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          User? user = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .userSingUp(email: email, password: password);

                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Sing Up Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.of(context).pushReplacementNamed(
                                'home_page',
                                arguments: user);
                          }
                        }
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
              "Already have account?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            CupertinoButton(
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
