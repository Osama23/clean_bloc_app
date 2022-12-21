import 'package:dartz/dartz.dart';
import 'package:posts_clean_bloc_app/features/posts/domain/repositories/posts_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

   @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        // cache posts
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(title: post.title, body: post.body);

    // if (await networkInfo.isConnected) {
    //   try {
    //     await remoteDataSource.addPost(postModel);
    //     return Right(unit);
    //   }  on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }

    return await _getMessage(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {

    // if (await networkInfo.isConnected) {
    //   try {
    //     await remoteDataSource.deletePost(postId);
    //     return Right(unit);
    //   }  on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }

    return await _getMessage(() {
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);

    // if (await networkInfo.isConnected) {
    //   try {
    //     await remoteDataSource.updatePost(postModel);
    //     return Right(unit);
    //   }  on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }

    return await _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  // Future<Either<Failure, Unit>> _getMessage2 (Future<Unit> Function()deleteOrUpdateOrAddPost) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //      await deleteOrUpdateOrAddPost;
  //       return Right(unit);
  //     }  on ServerException {
  //       return Left(ServerFailure());
  //     }
  //   } else {
  //     return Left(OfflineFailure());
  //   }
  // }
}
