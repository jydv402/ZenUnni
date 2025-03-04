class SearchModel {
  //todo : add fields for profile
  final String username;

  SearchModel({required this.username});

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(username: map['username'] ?? '');
  }

  // might need toMap() for local caching later
  Map<String, dynamic> toMap() {
    return {'username': username};
  }
}
