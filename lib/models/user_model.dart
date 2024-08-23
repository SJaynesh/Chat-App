class UserModel {
  String uid;
  String userName;
  String userEmail;
  String userProfilePic;

  UserModel({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.userProfilePic,
  });

  factory UserModel.formMap({required Map<String, dynamic> data}) {
    return UserModel(
      uid: data['uid'],
      userName: data['userName'],
      userEmail: data['userEmail'],
      userProfilePic: data['userProfilePic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userName": userName,
      "userEmail": userEmail,
      "userProfilePic": userProfilePic,
    };
  }
}
