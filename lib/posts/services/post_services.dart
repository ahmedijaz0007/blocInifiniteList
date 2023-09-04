

import 'package:http/http.dart' as http;
import 'package:infinitlist/constants.dart';
import 'package:infinitlist/network.dart';

class PostServices extends BaseServices{
  static PostServices instance = PostServices();
   PostServices();
  Future<http.Response> getPosts(http.Client httpClient,[int startIndex = 0,int postLimit = 20]) async {
    print("on event fetch services");
    super.params = <String, dynamic >{};
   // super.params["_start"] = startIndex;
   // super.params["_limit"] = postLimit;
    super.httpClient = httpClient;
    return await execute("/posts?_start=$startIndex&_limit=$postLimit", HttpType.get);
  }
}