part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class AddPostEvent extends PostEvent {
  final String message;
  final String username;
  AddPostEvent(this.message, this.username);
}

class LoadPostsEvent extends PostEvent {}
