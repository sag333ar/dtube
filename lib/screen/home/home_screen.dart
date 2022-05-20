import 'dart:developer';

import 'package:dtube/models/auth/user_stream.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/models/transaction/transaction_data.dart';
import 'package:dtube/screen/home/drawer.dart';
import 'package:dtube/screen/home/videos_list.dart';
import 'package:dtube/screen/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
    required this.title,
    required this.path,
    required this.shouldShowDrawer,
  }) : super(key: key);
  final String title;
  final String path;
  final bool shouldShowDrawer;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var isLoading = false;
  var hasError = false;
  List<NewVideosResponseModelItem> items = [];

  @override
  void initState() {
    super.initState();
    loadNewVideos();
  }

  void loadNewVideos() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    var request =
        http.Request('GET', Uri.parse('https://avalon.d.tube/${widget.path}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseValue = await response.stream.bytesToString();
      List<NewVideosResponseModelItem> items =
          decodeStringOfVideos(responseValue);
      setState(() {
        isLoading = false;
        hasError = false;
        this.items = items;
      });
    } else {
      setState(() {
        isLoading = false;
        hasError = true;
        items = [];
      });
    }
  }

  Widget loadingIndicator() {
    return Center(
      child: Column(
        children: const [
          Spacer(),
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text('Loading Data'),
          Spacer(),
        ],
      ),
    );
  }

  Widget body() {
    if (isLoading) {
      return loadingIndicator();
    }
    if (hasError) {
      return const Text('An Error occurred.');
    }
    if (items.isEmpty) {
      return const Text('No Data found.');
    }
    return VideosList(list: items);
  }

  void followProcess(String username, String key, String author) async {
    var jsonString = TransactionData(target: author).toJsonString();
    const platform = MethodChannel('com.sagar.dtube/transact');
    setState(() {
      isLoading = true;
    });
    final String result = await platform.invokeMethod('perform', {
      'username': username,
      'key': key,
      'data': jsonString,
      'type': '7',
    });
    // var resultInt = int.tryParse(result);
    if (result.isNotEmpty) {
      log('Result is $result');
    } else {
      // show some toast here.
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget followButton(String username, String key, String author) {
    return IconButton(
      onPressed: () {
        followProcess(username, key, author);
      },
      icon: const Icon(Icons.add_alert),
    );
  }

  Widget iconButton() {
    var user = Provider.of<DTubeUserData?>(context);
    var username = user?.username;
    var key = user?.key;
    var search = IconButton(
      onPressed: () {
        var screen = const SearchScreen();
        var route = MaterialPageRoute(builder: (c) => screen);
        Navigator.of(context).push(route);
      },
      icon: const Icon(Icons.search),
    );
    if (username == null || key == null) return search;
    if (!(widget.path.startsWith("blog/"))) return search;
    var author = widget.path.replaceAll('blog/', '');
    return followButton(username, key, author);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          iconButton(),
        ],
      ),
      body: body(),
      drawer: widget.shouldShowDrawer ? const DTubeDrawer() : null,
    );
  }
}
