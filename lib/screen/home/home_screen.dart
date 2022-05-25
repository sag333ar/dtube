import 'dart:convert';
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
  Future<List<NewVideosResponseModelItem>>? _future;
  Future<List<String>>? _futureFollows;

  Future<List<NewVideosResponseModelItem>> loadNewVideos(
      DTubeUserData? user) async {
    var request =
        http.Request('GET', Uri.parse('https://avalon.d.tube/${widget.path}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseValue = await response.stream.bytesToString();
      List<NewVideosResponseModelItem> items =
          decodeStringOfVideos(responseValue);
      return items;
    } else {
      log(response.reasonPhrase ?? 'Status code not 200');
      throw response.reasonPhrase ?? 'Status code not 200';
    }
  }

  Future<List<String>> getFollows(DTubeUserData? user) async {
    var user = Provider.of<DTubeUserData?>(context, listen: false);
    var username = user?.username;
    var key = user?.key;
    if (username != null && key != null && !widget.path.startsWith('blog/')) {
      return [];
    }
    var request = http.Request(
        'GET', Uri.parse('https://avalon.d.tube/follows/${username!}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseValue = await response.stream.bytesToString();
      var list = json.decode(responseValue) as List<dynamic>;
      List<String> items = list.map((listE) => listE.toString()).toList();
      return items;
    } else {
      throw 'Something went wrong while loading follows';
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

  Widget body(DTubeUserData? user) {
    if (_future == null) {
      _future = loadNewVideos(user);
    }
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
              'An Error occurred. ${snapshot.error?.toString() ?? 'Unknown Error'}');
        } else if (snapshot.hasData) {
          return VideosList(
            list: snapshot.data as List<NewVideosResponseModelItem>,
          );
        } else {
          return loadingIndicator();
        }
      },
    );
  }

  void followProcess(
      List<String> follows, String author, DTubeUserData user) async {
    var jsonString = TransactionData(target: author).toJsonString();
    const platform = MethodChannel('com.sagar.dtube/transact');
    setState(() {
      isLoading = true;
    });
    final String result = await platform.invokeMethod('perform', {
      'username': user.username,
      'key': user.key,
      'data': jsonString,
      'type': follows.contains(author) ? '8' : '7',
    });
    var txResult = TransactionResult.fromJsonString(result);
    if (txResult.err?.error != null && txResult.err?.error.isNotEmpty == true) {
      var snackBar = SnackBar(content: Text('Error: ${txResult.err!.error}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var text = follows.contains(author)
          ? 'You\'ve unfollowed $author'
          : 'You are now following $author';
      var snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _futureFollows = _futureFollows = getFollows(user);
      isLoading = false;
    });
  }

  Widget followButton(String author, DTubeUserData user) {
    return FutureBuilder(
      future: _futureFollows,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const SizedBox(width: 5);
        }
        if (snapshot.hasData) {
          var follows = snapshot.data as List<String>;
          return IconButton(
            onPressed: () async {
              followProcess(follows, author, user);
            },
            icon: Icon(follows.contains(author)
                ? Icons.person_remove_alt_1
                : Icons.person_add_alt_1),
          );
        }
        return const SizedBox(width: 5);
      },
    );
  }

  List<Widget> actions(DTubeUserData? user) {
    if (isLoading) return [const CircularProgressIndicator()];
    if (user?.username == null ||
        user?.key == null ||
        !(widget.path.startsWith("blog/"))) {
      return [
        IconButton(
          onPressed: () {
            var screen = const SearchScreen();
            var route = MaterialPageRoute(builder: (c) => screen);
            Navigator.of(context).push(route);
          },
          icon: const Icon(Icons.search),
        )
      ];
    }
    var author = widget.path.replaceAll('blog/', '');
    return [followButton(author, user!)];
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DTubeUserData?>(context);
    if (_futureFollows == null) {
      _futureFollows = getFollows(user);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: actions(user),
      ),
      body: body(user),
      drawer: widget.shouldShowDrawer ? const DTubeDrawer() : null,
    );
  }
}
