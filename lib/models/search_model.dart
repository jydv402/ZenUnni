class SearchModel {
  final String username;
  final int score;
  int? rank;

  SearchModel({required this.username, required this.score, this.rank});

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
