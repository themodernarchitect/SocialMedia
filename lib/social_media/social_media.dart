import 'package:flutter/material.dart';
import '../demo_auth.dart';

class Post {
  final String username;
  final String content;
  int likes = 0;
  bool isLiked = false;
  final List<String> comments = [];

  Post({required this.username, required this.content});
}

class CreatePostSheet extends StatefulWidget {
  final String username;

  const CreatePostSheet({super.key, required this.username});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    Navigator.of(context).pop(
      Post(username: widget.username, content: text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Posting as ${widget.username}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              child: const Text('Post'),
            ),
          ),
        ],
      ),
    );
  }
}

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

class SocialMediaPage extends StatefulWidget {
  final String username;

  const SocialMediaPage({
    super.key,
    required this.username,
  });

  @override
  State<SocialMediaPage> createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final List<Post> posts = [];

  Future<void> openCreatePost() async {
    final Post? newPost = await showModalBottomSheet<Post>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return CreatePostSheet(username: widget.username);
      },
    );

    if (!mounted || newPost == null) {
      return;
    }

    setState(() {
      posts.insert(0, newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: posts.isEmpty
          ? const Center(child: Text('No posts yet. Tap + to create one.'))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  key: ObjectKey(posts[index]),
                  post: posts[index],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCreatePost,
        icon: const Icon(Icons.add),
        label: const Text('Create Post'),
      ),
    );
  }
}