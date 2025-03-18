part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostsLoaded extends PostState {
  final Stream<QuerySnapshot> posts;
  PostsLoaded(this.posts);
}
