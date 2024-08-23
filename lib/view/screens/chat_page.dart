import 'package:chat_app/models/chat_modal.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  User? currentUser =
      FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    TextEditingController chatController = TextEditingController();
    UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          user.userName,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getChatData(
                    senderId: currentUser!.uid, recivedId: user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("No Chat Available"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChats =
                        data?.docs ?? [];
                    List<ChatModal> chats = allChats
                        .map((e) => ChatModal.fromMap(data: e.data()))
                        .toList();
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        ChatModal chatmodel = chats[index];
                        return (chatmodel.type == 'sent')
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        chatmodel.msg,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.purpleAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        chatmodel.msg,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Expanded(
              child: TextField(
                controller: chatController,
                onSubmitted: (val) async {
                  ChatModal chatModal = ChatModal(
                    val,
                    "sent",
                    DateTime.now(),
                  );

                  await FireStoreHelper.fireStoreHelper.sendChat(
                    senderId: currentUser!.uid,
                    receiverId: user.uid,
                    chatModal: chatModal,
                  );
                  chatController.clear();
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
