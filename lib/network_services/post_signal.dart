import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recyclean/constrants/constrants.dart';
import 'dart:convert';

class DepotController {
  Future Depot({
    required String image_signal,
    required String text_description,
    // required String long,
    // required String lat,
  }) async {
    try {
      var data = {
        "image_signal": image_signal,
        "text_description": text_description,
        // "long": long,
        // "lat": lat,
      };
      final response = await http.post(Uri.parse(Myurl + "api/depot"),body: data);
      bool status = jsonDecode(response.body);
      if (status) {
        final datas = jsonDecode(response.body)['message'];
        return datas;
      }
    } catch (e) {
     return e;
    }
  }
}
