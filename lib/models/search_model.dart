class SearchModel {
  final String username;
  final int score;
  int? rank;
  bool? isUser;

  SearchModel(
      {required this.username, required this.score, this.rank, this.isUser});

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      username: map['username'] ?? '',
      score: map['score'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'score': score,
    };
  }
}
