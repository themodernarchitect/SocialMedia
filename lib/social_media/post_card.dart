import 'package:flutter/material.dart';
import '../demo_auth.dart';
import 'post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      final p = widget.post;
      p.isLiked = !p.isLiked;
      p.likes += p.isLiked ? 1 : -1;
    });
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.post.comments.add(
        '${DemoAuth.currentUsername ?? 'unknown'}: $text',
      );
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content),
            Row(
              children: [
                IconButton(
                  onPressed: toggleLike,
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined, size: 20),
                const SizedBox(width: 4),
                Text('${post.comments.length}'),
              ],
            ),
            const Divider(),
            for (final c in post.comments)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(c),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      isDense: true,
                    ),
                    onSubmitted: (_) => addComment(),
                  ),
                ),
                IconButton(
                  onPressed: addComment,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}