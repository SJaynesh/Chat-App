class ChatRoomModel {
  String chatroomId;
  List<String> chatroomUser;

  ChatRoomModel({
    required this.chatroomId,
    required this.chatroomUser,
  });

  factory ChatRoomModel.fromMap({required Map<String, dynamic> data}) {
    return ChatRoomModel(
      chatroomId: data['chatroomId'],
      chatroomUser: data['chatroomUser'],
    );
  }
}
