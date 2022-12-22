import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:posts_clean_bloc_app/core/app_theme.dart';
import 'package:posts_clean_bloc_app/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:posts_clean_bloc_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_clean_bloc_app/features/posts/presentation/pages/posts_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => di.sl<PostsBloc>()..add(GetPostsListEvent())),
          BlocProvider(create: (_) => di.sl<AddDeleteUpdatePostBloc>()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Posts App',
            home: PostsPage()),
    );
  }
}
