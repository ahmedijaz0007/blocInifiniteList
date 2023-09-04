import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:infinitlist/posts/repository/post_repository.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

import '../model/model.dart';

part 'post_event.dart';
part 'post_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository})
      : super(const PostState(
            status: PostStatus.initial, hasReachedMax: false, posts: [])) {
    on<PostEvent>(transformer: throttleDroppable(throttleDuration),
        (event, emit) async {
      if (event is PostFetchEvent) {
       await _onPostFetched(event, emit);
      }
    });
  }

   _onPostFetched(
      PostFetchEvent event, Emitter<PostState> emit) async {
    print("on event fetch bloc");
    if (state.hasReachedMax) return;
    try {

      if (state.status == PostStatus.initial) {
          await postRepository.getPosts().then ((posts) async {
           print("post == $posts");
           await Future.delayed(const Duration(seconds: 2));
           return emit(state.copyWith(
              status: PostStatus.success, posts: posts, hasReachedMax: false));
        });
      }
      else{
          await postRepository.getPosts(startIndex: state.posts.length).then((posts) async {
            print("post2 == $posts");
            return emit(posts.isEmpty
                ? state.copyWith(hasReachedMax: true)
                : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
          });

      }
    } catch (e) {
      print("emitting failure state");
      print(e);
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
