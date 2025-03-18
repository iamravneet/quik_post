import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  PostBloc(this._postRepository) : super(PostInitial()) {
    on<AddPostEvent>((event, emit) async {
      await _postRepository.addPost(event.message, event.username);
    });

    on<LoadPostsEvent>((event, emit) {
      emit(PostsLoaded(_postRepository.getPosts()));
    });
  }
}
