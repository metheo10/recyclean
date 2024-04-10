import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recyclean/constrants/constrants.dart';
import 'package:recyclean/models/signal_model.dart';
import 'package:http/http.dart' as http;

class MyActivities extends StatefulWidget {
  const MyActivities({super.key});

  @override
  State<MyActivities> createState() => _MyActivitiesState();
}

class _MyActivitiesState extends State<MyActivities> {
  bool isSee = false;

  void isSeen() {
    setState(() {
      isSee = !isSee;
    });
  }

  late Future<List<Signal>?> listSignals;

  Future<List<Signal>?> getSignals() async {
    final response = await http.get(Uri.parse(Myurl + "/api/depot"));

    List<Signal> listSignal = [];
    if (response.statusCode == 200) {
      for (var signal in jsonDecode(response.body)) {
        Signal depots = Signal.fromjson(signal);
        listSignal.add(depots);
      }
      return listSignal;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    listSignals = getSignals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "MON HISTORIQUE",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: ListView(
        children: [
          Expanded(
              child: FutureBuilder<List<Signal>?>(
            future: listSignals,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return isSee
                              ? Container(
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.greenAccent,
                                        width: 4,
                                        style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.radio_button_checked,
                                            color: Colors.green,
                                          ),
                                          Text("{}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                isSeen();
                                              },
                                              icon: isSee
                                                  ? Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_drop_up,
                                                      color: Colors.white,
                                                    ))
                                        ],
                                      ),
                                    ],
                                  ))
                              : Container(
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.radio_button_checked,
                                            color: Colors.green,
                                          ),
                                          Text("Alert du: 11/10/2023",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                isSeen();
                                              },
                                              icon: isSee
                                                  ? Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_drop_up,
                                                      color: Colors.white,
                                                    ))
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.greenAccent,
                                      ),
                                      Center(
                                          child: Text(
                                        "IMAGE DESCRIPTIVE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.greenAccent,
                                                width: 2,
                                                style: BorderStyle.solid),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          margin: EdgeInsets.all(8.0),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          child: Center(
                                            child: Image.network(
                                                "${snapshot.data![index].image_signal}"),
                                          )),
                                      Divider(
                                        color: Colors.greenAccent,
                                      ),
                                      Center(
                                          child: Text(
                                        "TEXT DESCRIPTIF",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.greenAccent,
                                              width: 2,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        margin: EdgeInsets.all(8.0),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Center(
                                            child: Text(
                                                "${snapshot.data![index].text_description}")),
                                      ),
                                    ],
                                  ),
                                );
                        })
                    : Center(
                        child: Text("Aucune donnee active...",
                            style: TextStyle(color: Colors.red)));
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("Votre activite est encore vide...");
              } else {
                return Center(
                    child: Text("une erreur est survenue...",
                        style: TextStyle(color: Colors.red)));
              }
            },
          )),
        ],
      ),
    );
  }
}
