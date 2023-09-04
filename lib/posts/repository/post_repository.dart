

import 'dart:convert';
import 'dart:core';



import 'package:infinitlist/posts/services/post_services.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

class PostRepository{

  PostRepository({required this.httpClient});
  final  PostServices postService = PostServices();
  final http.Client httpClient;

  Future<List<Post>> getPosts({int? startIndex}) async {
    print("on event fetch repossitory");
    var response =  await postService.getPosts(http.Client(),startIndex ?? 0);
      final body = jsonDecode(response.body) as List;
      print("body is   $body");
      return body.map((dynamic data){
         var map = data as Map<String,dynamic>;
         return Post(
           userId: map['userId'],
           id: map['id'],
           title: map['title'],
           body: map['body'],
         );
      }).toList();
  }
}