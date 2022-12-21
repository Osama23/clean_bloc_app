import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:posts_clean_bloc_app/core/error/failures.dart';
import 'package:posts_clean_bloc_app/core/strings/failures.dart';
import 'package:posts_clean_bloc_app/features/posts/domain/entities/post.dart';
import 'package:posts_clean_bloc_app/features/posts/domain/usecases/get_all_posts.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUsecase getAllPosts;

  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetPostsListEvent) {
        emit(LoadingPostsState());

        final posts = await getAllPosts.call();

        posts.fold((failure) {
          emit(ErrorPostsState(_mapFailureToMessage(failure)));
        }, 
        (posts) {
          emit(LoadedPostsState(posts: posts));
        });
      } else if (event is RefreshPostsListEvent) {
        emit(LoadingPostsState());

        final failureOrPosts = await getAllPosts.call();
        emit(_mapFailureOrPostsToState(failureOrPosts));
        // posts.fold((failure) {
        //   emit(ErrorPostsState(_mapFailureToMessage(failure)));
        // },
        // (posts) {
        //   emit(LoadedPostsState(posts: posts));
        // });
      }
    });
  }

  PostsState _mapFailureOrPostsToState(Either<Failure, List<Post>> either) {
    return either.fold(
          (failure) => ErrorPostsState(_mapFailureToMessage(failure)),
          (posts) => LoadedPostsState(
        posts: posts,
      ),
    );
  }


  // get failure type server or client
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
