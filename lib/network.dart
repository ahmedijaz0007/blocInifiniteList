import 'dart:convert' as convert;
import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'package:infinitlist/constants.dart';

class BaseServices {
   late Map<String,dynamic> params;


  Future<http.Response> execute(String actionName, HttpType httpType,) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview

     var url = Uri.parse(baseUrl+actionName);
     Map<String, String> headers = {
       'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${CacheManager().apiToken}'
     };
   var response;
    switch(httpType){
      case (HttpType.get):
       response = http.get(url,headers: headers);
      case (HttpType.put):
        response = http.put(url,headers: headers,body: params);
      case (HttpType.patch):
        response = http.patch(url,headers: headers,body: params);
      case (HttpType.post):
        response = http.post(url,headers: headers,body: params);
      case (HttpType.delete):
        response = http.delete(url,headers: headers,body: params);
    }
      if(!response.isNull && response.statusCode == "200"){
        return response;
      }
      throw http.ClientException("Invalid response");


    //  var jsonResponse =
    //  convert.jsonDecode(response.body) as Map<String, dynamic>;
    // if (response.statusCode == 200) {
    //
    //
    //   var itemCount = jsonResponse['totalItems'];
    //   print('Number of books about http: $itemCount.');
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
    // return jsonResponse;
  }

}