import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinitlist/posts/logic/post_bloc.dart';

import '../model/model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetchEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
      switch (state.status) {
        case PostStatus.initial:
          print('is Initial');
          context.read<PostBloc>().add(PostFetchEvent());
          return const Center(child: CircularProgressIndicator());
        case PostStatus.failure:
          return const Center(
            child: Text("Failure to Fetch Post"),
          );
        case PostStatus.success:
          return ListView.builder(
            itemBuilder: (context, index) {
              return index >= state.posts.length
                  ? const BottomLoader()
                  : PostListItem(post: state.posts[index]);
            },
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
          );
      }
    });
  }
}

class PostListItem extends StatelessWidget {
  final Post post;
  const PostListItem({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Text('${post.id}', style: textTheme.bodySmall),
      title: Text(post.title ?? 'blah'),
      isThreeLine: true,
      subtitle: Text(post.body ?? "blah"),
      dense: true,
    );
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
