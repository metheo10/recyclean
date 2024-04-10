import 'package:flutter/material.dart';
import 'package:recyclean/constrants/images_strings.dart';
import 'package:recyclean/pages/my_object.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Column(
                children: [
                  Image(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.6,
                    image: AssetImage(Oimages.onBoardingImage3),
                    ),
                    Text(MyObjects.text),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}