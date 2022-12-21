part of 'add_delete_update_post_bloc.dart';

@immutable
abstract class AddDeleteUpdatePostState {}

class AddDeleteUpdatePostInitial extends AddDeleteUpdatePostState {}

class LoadingAddDeleteUpdatePostState extends AddDeleteUpdatePostState {

}

class MessageAddDeleteUpdatePostState extends AddDeleteUpdatePostState {
  final String message;

  MessageAddDeleteUpdatePostState({required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorAddDeleteUpdateState extends AddDeleteUpdatePostState {
  final String message;

  ErrorAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}