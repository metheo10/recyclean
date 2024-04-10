import 'package:flutter/material.dart';
import 'package:recyclean/pages/my_object.dart';

class FacturePage extends StatefulWidget {
  const FacturePage({super.key});

  @override
  State<FacturePage> createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  late bool onSee = false;

  void onSeeing() {
    setState(() {
      onSee = !onSee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "MA FACTURATION",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: ListView(
        children: [
          !onSee
              ? Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.greenAccent,
                        width: 6,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payement du: " + MyObjects.date),
                      IconButton(
                          onPressed: () {
                            onSeeing();
                          },
                          icon: Icon(Icons.arrow_drop_down))
                    ],
                  ),
                )
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.greenAccent,
                          width: 6,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payement du: " + MyObjects.date),
                            IconButton(
                                onPressed: () {
                                  onSeeing();
                                },
                                icon: Icon(Icons.arrow_drop_up))
                          ],
                        ),
                        Center(
                          child: Text("Votre nom: " + MyObjects.name),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child:
                              Text("Montant transfere : " + MyObjects.account),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text("Date du transfert : " + MyObjects.date),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text("Recepteur : RECYCLEAN"),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          color: Colors.greenAccent,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text("RAISON"),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.greenAccent,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin: EdgeInsets.all(8.0),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Center(
                              child: Text("LA PHOTO DE SIGNALEMENT ICI")),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
