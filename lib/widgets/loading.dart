import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recyclean/pages/my_object.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: Center(
                  child: SpinKitThreeBounce(
                // size: 250,
                color: Colors.greenAccent,
              )),
            ),
            Text(
              "Produit par " + MyObjects.name,style: TextStyle(color: Colors.greenAccent),
            ),
          ]),
    );
  }
}
