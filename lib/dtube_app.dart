import 'package:dtube/models/auth/user_stream.dart';
import 'package:dtube/screen/home/home_screen.dart';
import 'package:dtube/server/dtube_app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class DTubeApp extends StatefulWidget {
  const DTubeApp({Key? key}) : super(key: key);

  @override
  State<DTubeApp> createState() => _DTubeAppState();
}

class _DTubeAppState extends State<DTubeApp> {
  // Create storage
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String? username = await storage.read(key: 'username');
    String? key = await storage.read(key: 'key');
    if (username != null &&
        key != null &&
        username.isNotEmpty &&
        key.isNotEmpty) {
      DTubeAppData.updateUserData(DTubeUserData(username: username, key: key));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<DTubeUserData?>.value(
      value: DTubeAppData.userData,
      initialData: null,
      child: const MaterialApp(
        title: 'D.tube',
        debugShowCheckedModeBanner: false,
        home: HomeWidget(
          title: 'New Videos',
          path: 'new',
          shouldShowDrawer: true,
        ),
      ),
    );
  }
}
