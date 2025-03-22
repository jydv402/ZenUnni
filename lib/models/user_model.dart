class UserModel {
  final String username;
  final int gender;
  final int avatar;

  UserModel({
    required this.username,
    required this.gender,
    required this.avatar,
  });

  // Convert Firestore data to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      gender: data['gender'] ?? 0, // Default: Male
      avatar: data['avatar'] ?? 0, // Default: First avatar
    );
  }

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'gender': gender,
      'avatar': avatar,
    };
  }
}
