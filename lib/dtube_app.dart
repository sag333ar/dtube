import 'package:dtube/screen/home/home_screen.dart';
import 'package:flutter/material.dart';

class DTubeApp extends StatelessWidget {
  const DTubeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'D.tube',
      home: HomeWidget(title: 'New Videos', path: 'new'),
    );
  }
}
