class UserModel {
  final String username;
  final int gender;
  final int avatar;
  final String about;
  final String freeTime;
  final String bedtime;

  UserModel({
    required this.username,
    required this.gender,
    required this.avatar,
    required this.about,
    required this.freeTime,
    required this.bedtime,
  });

  // Convert Firestore data to UserModelp
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      gender: data['gender'] ?? 0, // Default: Male
      avatar: data['avatar'] ?? 0, // Default: First avatar
      about: data['about'] ?? '',
      freeTime: data['freeTime'] ?? '',
      bedtime: data['bedtime'] ?? '',
    );
  }

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'gender': gender,
      'avatar': avatar,
      'about': about,
      'freeTime': freeTime,
      'bedtime': bedtime,
    };
  }
}
