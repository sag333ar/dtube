import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<List<NewVideosResponseModelItem>> loadNewVideos() async {
    var request = http.Request('GET', Uri.parse('https://avalon.d.tube/new'));
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
    if (item.json.thumbnailUrl.isNotEmpty) {
      return item.json.thumbnailUrl;
    } else if (item.json.thumbnailUrlExternal.isNotEmpty) {
      return item.json.thumbnailUrlExternal;
    } else if (item.json.files.youtube.isNotEmpty) {
      return "https://img.youtube.com/vi/${item.json.files.youtube}/0.jpg";
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
              // responseItems[index].json.title,
              style: Theme.of(context).textTheme.bodyText1),
          Text(subtitle,
              //'${responseItems[index].author}, DTC ${responseItems[index].dist}, ${responseItems[index].json.tag}',
              style: Theme.of(context).textTheme.bodyText2)
        ],
      ),
    );
  }

  Widget videoInfo(NewVideosResponseModelItem item) {
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
            item.json.title,
            '${item.author}, DTC ${item.dist}, ${item.json.tag}',
          )
        ],
      ),
    );
  }

  Widget videoThumbnail(NewVideosResponseModelItem item) {
    return SizedBox(
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
    );
  }

  Widget videoListTile(NewVideosResponseModelItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          videoThumbnail(item),
          videoInfo(item)
        ],
      ),
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
          return listOfVideoTiles(snapshot.data as List<NewVideosResponseModelItem>);
        } else {
          return loadingIndicator();
        }
      },
    );
  }

  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Videos from D.Tube'),
      ),
      body: IndexedStack(
        children: [
          body(),
          const Text('Trending screen'),
          const Text('Favorites screen'),
          const Text('Community screen'),
          const Text('Settings screen'),
        ],
        index: _index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.black87),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'Trending', backgroundColor: Colors.black87),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites', backgroundColor: Colors.black87),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community', backgroundColor: Colors.black87),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting', backgroundColor: Colors.black87),
        ],
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
