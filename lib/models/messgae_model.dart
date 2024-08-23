class MessageModel {
  String sender;
  String text;
  bool seen;
  DateTime time;

  MessageModel({
    required this.sender,
    required this.text,
    required this.seen,
    required this.time,
  });

  factory MessageModel.fromMap({required Map<String, dynamic> data}) {
    return MessageModel(
      sender: data['sender'],
      text: data['text'],
      seen: data['seen'],
      time: data['time'],
    );
  }
}
