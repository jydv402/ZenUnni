class SearchModel {
  final String username;
  final int score;
  final int gender;
  final int avatar;
  int? rank;
  bool? isUser;

  SearchModel(
      {required this.username,
      required this.score,
      this.gender = 0,
      this.avatar = 0,
      this.rank,
      this.isUser});

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      username: map['username'] ?? '',
      score: map['score'] ?? 0,
      gender: map['gender'] ?? 0,
      avatar: map['avatar'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'score': score,
      'gender': gender,
      'avatar': avatar,
    };
  }
}
