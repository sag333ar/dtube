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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Videos from D.Tube'),
      ),
      body: FutureBuilder(
        future: loadNewVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'An Error occured. ${snapshot.error?.toString() ?? 'Unknown Error'}');
          } else if (snapshot.hasData) {
            var responseItems =
                snapshot.data as List<NewVideosResponseModelItem>;
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Column(
                      children: [
                        SizedBox(
                          height: 240,
                          width: MediaQuery.of(context).size.width,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/not_found_thumb.png',
                            image: getVideoThumbnailUrl(responseItems[index]),
                            imageErrorBuilder: (context, error, trace) {
                              return Image.asset('images/not_found_thumb.png');
                            },
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: Image.network(
                                        'https://avalon.d.tube/image/avatar/${responseItems[index].author}/small')
                                    .image,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(responseItems[index].json.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Text('${responseItems[index].author}, DTC ${responseItems[index].dist}, ${responseItems[index].json.tag}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2)
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemCount: responseItems.length);
          } else {
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
        },
      ),
    );
  }
}
