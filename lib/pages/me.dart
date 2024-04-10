import 'package:flutter/material.dart';
import 'package:recyclean/pages/my_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyViewPage extends StatefulWidget {
  const MyViewPage({super.key});

  @override
  State<MyViewPage> createState() => _MyViewPageState();
}

class _MyViewPageState extends State<MyViewPage> {
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

  @override
  Widget build(BuildContext context) {
    return isLooading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ))
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue,
                          shape: BoxShape.circle),
                      child: Image(image: AssetImage("images/froppy.png")),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      // margin: EdgeInsets.only(left: 50, right: 50),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amberAccent)),
                      child: Center(
                        child: Text(preferences.getString('name').toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        // width: MediaQuery.of(context).size.width * 0.2,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amberAccent)),
                        child: Center(
                          child: Text(preferences.getString('email').toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Center(
                      child: Text(
                        "Membre depuis: " + MyObjects.date,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
