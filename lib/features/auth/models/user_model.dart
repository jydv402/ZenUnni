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
      username: (data['username'] ?? '') as String,
      gender: (data['gender'] ?? 0) as int, // Default: Male
      avatar: (data['avatar'] ?? 0) as int, // Default: First avatar
      about: (data['about'] ?? '') as String,
      freeTime: (data['freeTime'] ?? '') as String,
      bedtime: (data['bedtime'] ?? '') as String,
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
