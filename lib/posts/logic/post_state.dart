part of 'post_bloc.dart';
enum PostStatus { initial, success, failure }


final class PostState extends Equatable {

  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

   const PostState({required this.status,required this.hasReachedMax,required this.posts});

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object?> get props => [status,posts,hasReachedMax];

  PostState copyWith({
     PostStatus? status,
     List<Post>? posts,
    bool? hasReachedMax
  }) {
    return PostState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}





