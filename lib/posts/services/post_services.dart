

import 'package:http/http.dart' as http;
import 'package:infinitlist/constants.dart';
import 'package:infinitlist/network.dart';

class PostServices extends BaseServices{

  Future<http.Response> getPosts() async {
    //super.params = Map();
    return await execute("posts", HttpType.get);
  }
}