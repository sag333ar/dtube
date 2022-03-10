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
      List<NewVideosResponseModelItem> items = decodeStringOfVideos(responseValue);
      return items;
    }  else {
      log(response.reasonPhrase ?? 'Status code not 200');
      throw response.reasonPhrase ?? 'Status code not 200';
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
            return Text('An Error occured. ${snapshot.error?.toString() ?? 'Unknown Error'}');
          } else if (snapshot.hasData) {
            var responseItems = snapshot.data as List<NewVideosResponseModelItem>;
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(responseItems[index].json.title),
                    leading: Image.asset('images/dtube_logo.png'),
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
                  SizedBox(height: 10,),
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
