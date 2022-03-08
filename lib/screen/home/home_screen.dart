import 'dart:developer';

import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<String> people = [
    "Heimin",
    "Nannal",
    "TibFox",
    "CamStubs",
    "Brish",
    "Sagar"
  ];

  void addDateTimeStamp() {
    var value = DateTime.now().toIso8601String();
    setState(() {
      people.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Videos from D.Tube'),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(people[index]),
              leading: Image.asset('images/dtube_logo.png'),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: people.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('Button Clicked');
          addDateTimeStamp();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
