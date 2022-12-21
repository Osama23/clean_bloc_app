part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {
  const PostsEvent();
}

// A event to get posts lists
class GetPostsListEvent extends PostsEvent {
  const GetPostsListEvent();
  @override
  List<Object?> get props => [];
}

// A event to refresh posts lists
class RefreshPostsListEvent extends PostsEvent {
  const RefreshPostsListEvent();
  @override
  List<Object?> get props => [];
}




