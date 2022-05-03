import 'dart:developer';

import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/screen/auth/login_screen.dart';
import 'package:dtube/screen/details/video_details.dart';
import 'package:dtube/screen/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class HomeWidget extends StatefulWidget {
  const HomeWidget(
      {Key? key,
      required this.title,
      required this.path,
      required this.shouldShowDrawer})
      : super(key: key);
  final String title;
  final String path;
  final bool shouldShowDrawer;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<List<NewVideosResponseModelItem>> loadNewVideos() async {
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

  String getVideoThumbnailUrl(NewVideosResponseModelItem item) {
    if (item.jsonObject.thumbnailUrl.isNotEmpty) {
      return item.jsonObject.thumbnailUrl;
    } else if (item.jsonObject.thumbnailUrlExternal.isNotEmpty) {
      return item.jsonObject.thumbnailUrlExternal;
    } else if (item.jsonObject.files.youtube.isNotEmpty) {
      return "https://img.youtube.com/vi/${item.jsonObject.files.youtube}/0.jpg";
    } else {
      return "";
    }
  }

  Widget titleAndSubtitle(String title, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              // responseItems[index].jsonObject.title,
              style: Theme.of(context).textTheme.bodyText1),
          Text(subtitle,
              //'${responseItems[index].author}, DTC ${responseItems[index].dist}, ${responseItems[index].jsonObject.tag}',
              style: Theme.of(context).textTheme.bodyText2)
        ],
      ),
    );
  }

  Widget videoInfo(NewVideosResponseModelItem item) {
    var upvotes = item.votes.where((element) => element.vt > 0).length - 1;
    var dowvotes = item.votes.where((element) => element.vt < 0).length;
    var dateTime = timeago.format(DateTime.fromMillisecondsSinceEpoch(item.ts));
    var dtcValue = item.dist / 100.0;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(
                    'https://avalon.d.tube/image/avatar/${item.author}/small')
                .image,
          ),
          const SizedBox(width: 5),
          titleAndSubtitle(
            item.jsonObject.title,
            '${item.author}, DTC ${dtcValue.toStringAsFixed(2)} $dateTime ${upvotes > 0 ? '👍 $upvotes' : ''} ${dowvotes > 0 ? '👎 $dowvotes' : ''}',
          )
        ],
      ),
    );
  }

  Widget videoThumbnail(NewVideosResponseModelItem item) {
    return Stack(children: [
      SizedBox(
        height: 240,
        width: MediaQuery.of(context).size.width,
        child: FadeInImage.assetNetwork(
          placeholder: 'images/not_found_thumb.png',
          image: getVideoThumbnailUrl(item),
          imageErrorBuilder: (context, error, trace) {
            return Image.asset('images/not_found_thumb.png');
          },
          fit: BoxFit.fitWidth,
        ),
      ),
      Row(
        children: [
          const Spacer(),
          Image.asset(item.jsonObject.files.youtube.isEmpty
              ? 'images/ipfs.png'
              : 'images/yt.png'),
          const SizedBox(
            width: 5,
          )
        ],
      )
    ]);
  }

  Widget videoListTile(NewVideosResponseModelItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [videoThumbnail(item), videoInfo(item)],
      ),
      onTap: () {
        var screen = VideoDetailsScreen(item: item);
        var route = MaterialPageRoute(builder: (c) => screen);
        Navigator.of(context).push(route);
      },
    );
  }

  Widget listOfVideoTiles(List<NewVideosResponseModelItem> list) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return videoListTile(list[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: list.length);
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
    return FutureBuilder(
      future: loadNewVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
              'An Error occured. ${snapshot.error?.toString() ?? 'Unknown Error'}');
        } else if (snapshot.hasData) {
          return listOfVideoTiles(
              snapshot.data as List<NewVideosResponseModelItem>);
        } else {
          return loadingIndicator();
        }
      },
    );
  }

  void pushHomeFeed({required String title, required String path}) {
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
    return ListView(
      children: [
        _drawerHeader(context),
        ListTile(
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
            pushHomeFeed(title: 'Hot Videos', path: 'hot');
          },
        ),
        ListTile(
          leading: const Icon(Icons.stream),
          title: const Text('Trending Videos'),
          onTap: () {
            pushHomeFeed(title: 'Trending Videos', path: 'trending');
          },
        ),
        ListTile(
          leading: const Icon(Icons.timelapse),
          title: const Text('New Videos'),
          onTap: () {
            pushHomeFeed(title: 'New Videos', path: 'new');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              var screen = const SearchScreen();
              var route = MaterialPageRoute(builder: (c) => screen);
              Navigator.of(context).push(route);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: body(),
      drawer:
          widget.shouldShowDrawer ? Drawer(child: _getDrawer(context)) : null,
    );
  }
}
