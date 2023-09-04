import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinitlist/observer.dart';
import 'package:infinitlist/posts/logic/post_bloc.dart';
import 'package:infinitlist/posts/presentation/PostScreen.dart';
import 'package:infinitlist/posts/repository/post_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final observer = const SimpleBlocObserver();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostRepository(httpClient: http.Client()),
      child: BlocProvider(
        create: (context) => PostBloc(postRepository: RepositoryProvider.of<PostRepository>(context)),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Scaffold(body: PostScreen()),
        ),
      ),
    );
  }
}



