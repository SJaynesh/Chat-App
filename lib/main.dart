import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/view/screens/chat_page.dart';
import 'package:chat_app/view/screens/home_page.dart';
import 'package:chat_app/view/screens/login_page.dart';
import 'package:chat_app/view/screens/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChatApp(),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute:
          (FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser !=
                  null)
              ? 'home_page'
              : '/',
      routes: {
        "/": (ctx) => LoginPage(),
        "sing_up_page": (ctx) => SignUpPage(),
        "home_page": (ctx) => HomePage(),
        "chat_page": (ctx) => ChatPage(),
      },
    );
  }
}
