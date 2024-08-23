import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  User? user = FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    // User user = ModalRoute.of(context)!.settings.arguments as User;
    return SafeArea(
      child: Scaffold(
        drawer: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(user!.photoURL ??
                    "https://st3.depositphotos.com/15648834/17930/v/450/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg"),
              ),
              accountName: Text("${user!.displayName ?? "Radhe Radhe"}"),
              accountEmail: Text("${user!.email}"),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text("Chat App"),
          actions: [
            CupertinoButton(
              child: Icon(Icons.logout_sharp),
              onPressed: () {
                FirebaseAuthHelper.firebaseAuthHelper.userLogout();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR : ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allData =
                  data?.docs ?? [];

              List<UserModel> myData = allData
                  .map((e) => UserModel.formMap(data: e.data()))
                  .toList();

              return ListView.builder(
                itemCount: myData.length,
                itemBuilder: (context, i) {
                  UserModel data = myData[i];
                  return (data.uid != user!.uid)
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('chat_page', arguments: data);
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(data.userProfilePic),
                          ),
                          title: Text(
                            data.userName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        )
                      : Text("");
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
