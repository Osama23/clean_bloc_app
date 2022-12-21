part of 'add_delete_update_post_bloc.dart';

abstract class AddDeleteUpdatePostEvent extends Equatable {
  const AddDeleteUpdatePostEvent();

  @override
  List<Object> get props => [];
}


// A event to add post
class AddPostEvent extends AddDeleteUpdatePostEvent {
  final Post post;
  const AddPostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

// A event to delete posts lists
class DeletePostEvent extends AddDeleteUpdatePostEvent {
  final int postId;
  const DeletePostEvent({required this.postId});  @override

  List<Object> get props => [postId];
}


// A event to delete posts lists
class UpdatePostEvent extends AddDeleteUpdatePostEvent {
  final Post post;
  const UpdatePostEvent({required this.post});  @override

  @override
  List<Object> get props => [post];
}