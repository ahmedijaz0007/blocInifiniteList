

import 'dart:convert';
import 'dart:core';
import 'dart:core';



import 'package:infinitlist/posts/services/post_services.dart';

import '../model/model.dart';

class PostRepository{

  static  PostServices postService = PostServices();

  Future<List<Post>> getPosts() async {
    var response =  await postService.getPosts();
      final body = jsonDecode(response.body) as List;
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