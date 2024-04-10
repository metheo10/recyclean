// import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:recyclean/constrants/constrants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:recyclean/models/user_model.dart';
import 'package:recyclean/network_services/api.dart';
import 'package:recyclean/network_services/check_internet.dart';
import 'package:recyclean/pages/authPages/authentication.dart';
import 'package:recyclean/pages/authPages/register_page.dart';
import 'package:recyclean/pages/home_page.dart';
import 'package:recyclean/pages/my_object.dart';
import 'package:recyclean/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthenticationController authentication = AuthenticationController();
  bool isLoggIn = false;
  bool _loading = false;

  late Future<List<User>?> listUsers;
  bool isConnected = false;
  bool visible = false;

  void isVisible() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          setState(() {
            isConnected = true;
          });
          break;
        default:
          setState(() {
            isConnected = false;
          });
      }
    });
  }

  void login() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState!.validate()) {
      final data = {
        "email": email.text,
        "password": password.text,
      };
      final http.Response result =
          await API().postRequest(route: "api/login", data: data);

      final response = (jsonDecode(result.body));
      if (result.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('user_id', response['user']['id']);
        preferences.setString('name', response['user']['name']);
        preferences.setString('email', response['user']['email']);
        preferences.setInt('phone', response['user']['phone']);
        preferences.setString('token', response['token']);

        setState(() {
          _loading = true;
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);

        return showDialog(
            context: context,
            builder: ((context) {
              return CheckData(
                texte: response['message '] + response['user']['name'],
                icon: Icon(
                  Icons.done_outline_sharp,
                  color: Colors.greenAccent,
                ),
              );
            }));
      } else if (result.statusCode == 401) {
        setState(() {
          _loading = false;
        });
        if (response['data'] == 'email_password_incorrect') {
          return showDialog(
            context: context,
            builder: (context) {
              return CheckData(
                  texte: response['data'],
                  icon: Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ));
            },
          );
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? LoadingPage()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: ListView(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(width: 4, color: Colors.white),
                        shape: BoxShape.circle,
                        // image: DecorationImage(image: ,fit: BoxFit.cover,)
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 10, right: 10),
                              child: TextFormField(
                                controller: email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "veillez renseigner votre email";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  hintText: MyObjects.email,
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  labelText: "Votre Email",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: TextFormField(
                                controller: password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "veillez renseigner votre mot de passe";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: visible ? false : true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        isVisible();
                                      },
                                      icon: visible
                                          ? Icon(
                                              Icons.visibility_off,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                            )),
                                  hintText: "********",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  errorStyle: TextStyle(color: Colors.blue),
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  labelText: "Entrer votre mot de passe",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "mot de passe oublier ?",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "REINITIALISER",
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      // if (isConnected)
                      OutlinedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            "CONFIRMER",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w800),
                          )),
                      // if (!isConnected)
                      // Text(
                      //   "Verifiez votre connexion internet",
                      //   style: TextStyle(
                      //       color: Colors.red, fontWeight: FontWeight.bold),
                      // ),
                    ]),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "creer un compte ?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()),
                                  (route) => false);
                            },
                            child: Text(
                              "S'INSCRIRE",
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class Loggin extends StatefulWidget {
  const Loggin({super.key});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            Center(
              child: Icon(
                Icons.warning,
                color: Colors.amber,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.only(top: 18, bottom: 18),
              child: Center(
                  child: Text(
                "MOT DE PASSE OU EMAIL INCORRECT",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CheckData extends StatefulWidget {
  final String texte;
  final Icon icon;
  CheckData({
    super.key,
    required this.texte,
    required this.icon,
  });

  @override
  State<CheckData> createState() => _CheckDataState();
}

class _CheckDataState extends State<CheckData> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            Center(
              child: widget.icon,
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.only(top: 18, bottom: 18),
              child: Center(
                  child: Text(
                widget.texte,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            )
          ],
        ),
      ),
    );
    ;
  }
}
