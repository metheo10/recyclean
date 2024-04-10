import 'package:flutter/material.dart';
import 'package:recyclean/widgets/themes.dart';

class settingPage extends StatefulWidget {
  final ThemeType themeType;
  final ValueChanged<ThemeType> onChanged;
  settingPage({super.key, required this.themeType, required this.onChanged});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  late String lang = "par default: FR";
  bool isDark = false;
  void isDarkness() {
    setState(() {
      isDark = !isDark;
    });
  }

  void _select(value) {
    switch (value) {
      case "Fr":
        setState(() {
          lang = "Fr";
        });
        ;
        break;
      case "En":
        setState(() {
          lang = "En";
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "PARAMETRES",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "THEMES",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            isDarkness();
                          },
                          label: Text("Mode Claire"),
                          icon: isDark
                              ? Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.radio_button_off,
                                  color: Colors.blue,
                                ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            isDarkness();
                          },
                          label: Text("Mode Sombre"),
                          icon: !isDark
                              ? Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.radio_button_off,
                                  color: Colors.blue,
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choisissez votre langue:  " + lang),
                  PopupMenuButton(
                      // color: bgs,
                      onSelected: _select,
                      itemBuilder: (BuildContext context) {
                        return {
                          "Fr",
                          "En",
                        }.map((String choice) {
                          return PopupMenuItem(
                              value: choice, child: Text(choice));
                        }).toList();
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}
