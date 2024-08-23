class ChatModal {
  String msg, type;
  DateTime dateTime;

  ChatModal(this.msg, this.type, this.dateTime);

  factory ChatModal.fromMap({required Map data}) => ChatModal(
        data['msg'],
        data['type'],
        DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      );

  String get getId => dateTime.millisecondsSinceEpoch.toString();

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'type': type,
        'dateTime': dateTime.millisecondsSinceEpoch,
      };
}
