import 'package:dtube/models/auth/user_stream.dart';
import 'package:dtube/screen/auth/login_screen.dart';
import 'package:dtube/screen/home/home_screen.dart';
import 'package:dtube/screen/my_channel/my_channel_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DTubeDrawer extends StatelessWidget {
  const DTubeDrawer({Key? key}) : super(key: key);

  void pushHomeFeed(
      {required String title,
      required String path,
      required BuildContext context}) {
    Navigator.of(context).pop();
    var screen = HomeWidget(title: title, path: path, shouldShowDrawer: true);
    var route = MaterialPageRoute(builder: (c) => screen);
    Navigator.of(context).pushReplacement(route);
  }

  Widget _drawerHeader(BuildContext context) {
    return DrawerHeader(
      child: InkWell(
        child: Column(
          children: [
            Image.asset(
              "images/dtube_logo.png",
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 5),
            Text(
              "DTube",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 5),
            Text(
              "sagar.kothari.88",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        onTap: () {
          // var screen = const AboutHomeScreen();
          // var route = MaterialPageRoute(builder: (_) => screen);
          // Navigator.of(context).push(route);
        },
      ),
    );
  }

  Widget _getDrawer(BuildContext context) {
    var user = Provider.of<DTubeUserData?>(context);
    var username = user?.username;
    return ListView(
      children: [
        _drawerHeader(context),
        username != null
            ? ListTile(
                leading: const Icon(Icons.video_collection),
                title: const Text('My Channel'),
                onTap: () {
                  Navigator.of(context).pop();
                  var screen = MyChannelScreen(
                      title: username,
                      path: 'accounts/$username',
                      shouldShowDrawer: true);
                  var route = MaterialPageRoute(builder: (c) => screen);
                  Navigator.of(context).push(route);
                },
              )
            : ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Login'),
                onTap: () {
                  Navigator.of(context).pop();
                  var screen = const LoginScreen();
                  var route = MaterialPageRoute(builder: (c) => screen);
                  Navigator.of(context).push(route);
                },
              ),
        ListTile(
          leading: const Icon(Icons.local_fire_department),
          title: const Text('Hot Videos'),
          onTap: () {
            pushHomeFeed(title: 'Hot Videos', path: 'hot', context: context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.stream),
          title: const Text('Trending Videos'),
          onTap: () {
            pushHomeFeed(
                title: 'Trending Videos', path: 'trending', context: context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.timelapse),
          title: const Text('New Videos'),
          onTap: () {
            pushHomeFeed(title: 'New Videos', path: 'new', context: context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: _getDrawer(context));
  }
}
