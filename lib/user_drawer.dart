import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recyclean/facture_page.dart';
import 'package:recyclean/pages/activities_page.dart';
import 'package:recyclean/pages/authPages/logout_page.dart';
import 'package:recyclean/pages/me.dart';
import 'package:recyclean/pages/settings_page.dart';
import 'package:recyclean/widgets/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String profileImage = '';
  late String image1;
  void getImage() async {
    ImagePicker picker = new ImagePicker();
    var pickerImage = await picker.pickImage(source: ImageSource.gallery);
    profileImage = pickerImage!.path;
    setState(() {
      image1 = profileImage;
    });
  }

  late SharedPreferences preferences;
  bool isLooading = false;

  void getUserData() async {
    setState(() {
      isLooading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLooading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  ThemeType _selectedTheme = ThemeType.light;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            border: Border.all(width: 4, color: Colors.white),
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: (profileImage == "")
                ? Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyViewPage(),
                              ));
                        },
                        child: Image(image: AssetImage("images/froppy.png"))))
                : Image.file(
                    File(profileImage),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
            bottom: 0,
            top: 0,
            right: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
                color: Colors.blue,
              ),
              child: IconButton(
                  onPressed: () {
                    getImage();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  )),
            )),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyActivities(),
                ));
          },
          child: ListTile(
            leading: Text(
              "Mon Historiques",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            trailing: Icon(Icons.list),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => settingPage(
                        themeType: ThemeType.light,
                        onChanged: (value) {
                          setState(() => _selectedTheme = value);
                        },
                      )),
            );
          },
          child: ListTile(
            leading: Text(
              "Parametres",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            trailing: Icon(Icons.settings),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacturePage(),
                ));
          },
          child: ListTile(
            leading: Text(
              "Mes facture",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            trailing: Icon(Icons.monetization_on),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: ListTile(
            leading: Text(
              "Partager l'application",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            trailing: Icon(
              Icons.share,
              color: Colors.blue,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: ListTile(
            leading: Text(
              "Noter l'application",
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            trailing: Icon(
              Icons.star_rate_sharp,
              color: Colors.amber,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return LogOutPage();
              },
            );
          },
          child: ListTile(
            leading: Text(
              "Deconnexion",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),
            ),
            trailing: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ),
      ],
    ));
  }
}
