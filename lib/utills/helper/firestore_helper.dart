import 'dart:developer';

import 'package:chat_app/models/chat_modal.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String userCollection = "User";

  Future<void> setUserData({required User user}) async {
    UserModel userModel = UserModel(
        uid: user.uid,
        userName: user.displayName ?? "Null",
        userEmail: user.email as String,
        userProfilePic: user.photoURL ??
            "https://st3.depositphotos.com/15648834/17930/v/450/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg");

    await firebaseFirestore
        .collection(userCollection)
        .doc(user.uid)
        .set(
          userModel.toMap(),
        )
        .then((value) {
      log("Data insert Successfully");
    });
  }

  Future<void> sendChat({
    required String senderId,
    required String receiverId,
    required ChatModal chatModal,
  }) async {
    chatModal.type = 'sent';

    await firebaseFirestore
        .collection(userCollection)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.getId)
        .set(chatModal.toMap);

    chatModal.type = 'received';

    await firebaseFirestore
        .collection(userCollection)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.getId)
        .set(
          chatModal.toMap,
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatData(
      {required String senderId, required String recivedId}) {
    return firebaseFirestore
        .collection(userCollection)
        .doc(senderId)
        .collection(recivedId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    return firebaseFirestore.collection(userCollection).snapshots();
  }
}
