import 'dart:async';
import 'dart:developer';

import 'package:dtube/models/auth/user_stream.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/models/new_videos_feed/search_response.dart';
import 'package:http/http.dart' as http;

class DTubeAppData {
  static final _dtubeDataController = StreamController<DTubeUserData?>();
  static Stream<DTubeUserData?> get userData {
    return _dtubeDataController.stream;
  }

  static void updateUserData(DTubeUserData? data) {
    _dtubeDataController.sink.add(data);
  }

  static Future<NewVideosResponseModelItem> loadContentDetails(
      String contentId) async {
    var request = http.Request(
        'GET', Uri.parse('https://avalon.d.tube/content/$contentId'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseValue = await response.stream.bytesToString();
      NewVideosResponseModelItem item =
          NewVideosResponseModelItem.fromJsonString(responseValue);
      return item;
    } else {
      log(response.reasonPhrase ?? 'Status code not 200');
      throw response.reasonPhrase ?? 'Status code not 200';
    }
  }

  static Future<SearchResponse> doSearch(String searchTerm) async {
    var searchText = searchTerm.trim();
    var url =
        'https://search.d.tube/avalon.accounts/_search?q=name:*$searchText*&size=50&sort=balance:desc';
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseValue = await response.stream.bytesToString();
      SearchResponse searchResponse =
          SearchResponse.fromJsonString(responseValue);
      return searchResponse;
    } else {
      log(response.reasonPhrase ?? 'Status code not 200');
      throw response.reasonPhrase ?? 'Status code not 200';
    }
  }
}
