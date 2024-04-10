import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:recyclean/constrants/constrants.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import 'package:recyclean/widgets/loading.dart';

class AuthenticationController {
  late String token = '';
  final box = GetStorage();
   bool _loading = false;

  // ignore: non_constant_identifier_names
  Future<String?> Register({
    required String name,
    required String phone,
    required String email,
    required String password,
    // final profile_image,
  }) async {
    try {
      var data = {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        // "profile_image": profile_image,
      };

      final res = await http.post(Uri.parse(Myurl + '/api/register'), body: data);
      if (res.statusCode == 200) {
        bool status = jsonDecode(res.body)['status'];
          final message =jsonDecode(res.body)['message'];
        if (status == true) {
          final datas = jsonDecode(res.body)['data'];

          if(datas['data']=="email_exist"){
            return "Email_existe_deja";
          }else if(datas['data']=="phone_exist"){
            return "numero_existe_deja";
          }else{
          token = datas['token'];
          }
        } else if(message['data']=='message'){
          return jsonDecode(res.body)['message'];
        }
      } else {
        return res.body;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future Login({
    required String email,
    required String password,
  }) async {
    try {
      var data = {
        'email': email,
        'password': password,
      };

      final res = await http.post(Uri.parse(Myurl + 'api/login'), body: data);
      if (res.statusCode == 200) {
        bool status = jsonDecode(res.body)['status'];
        if (status == true) {
          final datas = jsonDecode(res.body);
          if (datas['data'] == "email_password_incorrect") {
            return "email_password_incorrect";
          } else {
            token = jsonDecode(res.body)['token'];
            box.write('token', token);
          }
        } else {
          return "no_response";
        }
        // return res.body;
      } else {
        return "no_response";
      }
    } catch (e) {
      return e;
    }
  }
}
