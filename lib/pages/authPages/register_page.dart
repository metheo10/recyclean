import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:recyclean/constrants/constrants.dart';
import 'package:recyclean/models/user_model.dart';
import 'package:recyclean/network_services/api.dart';
import 'package:recyclean/pages/authPages/authentication.dart';
import 'package:recyclean/pages/authPages/login_page.dart';
import 'package:recyclean/pages/home_page.dart';
import 'package:recyclean/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isValidEmail(String _email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(_email);
  }

  bool isValidPassword(String _password) {
    RegExp regex = RegExp(
        r"^(?=.{8,255}$)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[~!@#$%^&*()_+|}{:;'?/.,]).*$");
    return regex.hasMatch(_password);
  }

  bool isValidPhone(String _phone) {
    RegExp regex = RegExp(r"^[0-9]{2,}$");
    return regex.hasMatch(_phone);
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _profileController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthenticationController _authenticationController =
      AuthenticationController();
  final _formKey = GlobalKey<FormState>();

  bool isObscuredPassword = false;

  void isVisible() {
    setState(() {
      isObscuredPassword = !isObscuredPassword;
    });
  }

  File? imagepath;
  String? imageName;
  String? imageData;
  // late FileImage image1;

  // void getImage() async {
  //   ImagePicker picker = new ImagePicker();
  //   var pickerImage = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     // image1 = FileImage(File(pickerImage!.path));
  //     imagepath = File(pickerImage!.path);
  //     imageName = pickerImage.path.split('/').last;
  //     imageData = base64Encode(imagepath!.readAsBytesSync());
  //     print("le contenu de l'image est: ${imagepath}");
  //   });
  // }

  late Future<List<User>?> listUsers;

  // Future<List<User>?> getUsers() async {
  //   final response = await http.post(Uri.parse(Myurl + "/api/register"));

  //   List<User> listUser = [];
  //   if (response.statusCode == 200) {
  //     for (var user in jsonDecode(response.body)) {
  //       User users = User.fromjson(user);
  //       listUser.add(users);
  //     }
  //     return listUser;
  //   }
  //   return null;
  // }

  bool isConnected = false;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    // listUsers = getUsers();

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

  void register() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_passwordController.value == _confirmPasswordController.value) {
        final data = {
          'name': _nameController.text.toString(),
          'phone': _phoneController.text.toString(),
          'email': _emailController.text.toString(),
          'password': _passwordController.text.toString()
        };
        // Qwerty1/
        final http.Response result =
            await API().postRequest(route: "api/register", data: data);
        final response = jsonDecode(result.body);
        if (result.statusCode == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt('id', response['user']['id']);
          preferences.setString('name', response['user']['name']);
          preferences.setString('email', response['user']['email']);
          preferences.setInt('phone', response['user']['phone']);
          preferences.setString('token', response['token']);
          setState(() {
            _loading = false;
          });

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);

          return showDialog(
              context: context,
              builder: ((context) {
                return CheckData(
                  texte: response['data'],
                  icon: Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ),
                );
              }));
        } else if (result.statusCode == 401) {
          setState(() {
            _loading = false;
          });
          if (response['data'] == 'ce compte existe deja') {
            return showDialog(
                context: context,
                builder: ((context) {
                  return CheckData(
                    texte: response['data'],
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow,
                    ),
                  );
                }));
          } else if (response['data'] == 'numero de telephone existe deja') {
            return showDialog(
                context: context,
                builder: ((context) {
                  return CheckData(
                    texte: response['data'],
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow,
                    ),
                  );
                }));
          }
        }
      }
      setState(() {
            _loading = false;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    _loading
        ? LoadingPage()
        : 
        Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {},
                child: ListView(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 20, right: 20),
                              child: TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veillez remplir ce champ";
                                  } else if (value.length < 0) {
                                    return "Le nom doit avoir minimum 3 caracteres";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  labelText: "Votre nom",
                                  hintText: "METHEO",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 20, right: 20),
                              child: TextFormField(
                                controller: _phoneController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veillez remplir ce champ";
                                  } else if (value.length < 9) {
                                    return "Le numero de telephone doit avoir minimum 9 caracteres";
                                  } else {
                                    return null;
                                  } // Validation réussie
                                },
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  hintText: "698640929",
                                  counterText: '',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  labelText: "Numero de telephone",
                                  errorStyle: TextStyle(color: Colors.blue),
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 20, right: 20),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veillez remplir ce champ";
                                  } else if (!isValidEmail(value)) {
                                    return "L'addresse email saisie n'est pas valide";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  hintText: "metheotheo@gmail.com",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  labelText: "Entrer votre email",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 20, right: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Creer un mot de passe";
                                  } else if (!isValidPassword(value)) {
                                    return "Le mot de passe doit contenir minimum 8 caracters, des lettres majuscules, des chiffre et des caracteres speciaux";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: isObscuredPassword ? false : true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        isVisible();
                                      },
                                      icon: isObscuredPassword
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
                                  labelText: "Creer un mot de passe",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30, left: 20, right: 20),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Confirmez votre mot de passe";
                                  } else if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    return "les mots de passent ne correspondent pas";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: isObscuredPassword ? false : true,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "********",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  errorStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          style: BorderStyle.solid)),
                                  labelText: "Confirmez votre mot de passe",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // if (isConnected)
                        OutlinedButton(
                            onPressed: () {
                              register();
                            },
                            child: Text(
                              "SOUMETTRE",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w800),
                            )),
                        // if (!isConnected)
                        //   Text(
                        //     "Verifiez votre connexion internet",
                        //     style: TextStyle(
                        //         color: Colors.red, fontWeight: FontWeight.bold),
                        //   ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Vous avez deja un compte ?",
                            style: TextStyle(color: Colors.blueAccent)),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            },
                            child: const Text(
                              "CONNEXION",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: Colors.greenAccent),
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

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            Center(
              child: Icon(
                Icons.warning,
                color: Colors.amber,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(top: 18, bottom: 18),
              child: Center(
                  child: Text(
                "MOT DE PASSE OU EMAIL INCORRECT",
                style: TextStyle(fontWeight: FontWeight.bold),
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
  }
}
