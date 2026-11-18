class Post {
  final String username;
  final String content;
  int likes = 0;
  bool isLiked = false;
  final List<String> comments = [];

  Post({required this.username, required this.content});
}