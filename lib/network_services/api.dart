import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recyclean/constrants/constrants.dart';

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = Myurl + route;
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _header(),
    );
  }

  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  // getRequest({}){}

  // putRequest({}){}

  // putRequest({}){}

  // putRequest({}){}
}
