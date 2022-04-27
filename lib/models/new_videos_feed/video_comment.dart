import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/models/new_videos_feed/safe_convert.dart';

class VideoComment {
  final String id;
  final String author;
  final String link;
  final String pa;
  final String pp;
  final VideoCommentJson json;
  final List<List<String>> child;
  final List<NewVideosResponseModelItemVotesItem> votes;
  final int ts;
  final double dist;

  bool isVisited;
  int level;

  VideoComment({
    this.id = "",
    this.author = "",
    this.link = "",
    this.pa = "",
    this.pp = "",
    required this.json,
    required this.child,
    required this.votes,
    this.ts = 0,
    this.dist = 0.0,
    this.isVisited = false,
    this.level = 0,
  });

  factory VideoComment.fromJson(Map<String, dynamic>? json) => VideoComment(
        id: asString(json, '_id'),
        author: asString(json, 'author'),
        link: asString(json, 'link'),
        pa: asString(json, 'pa'),
        pp: asString(json, 'pp'),
        json: VideoCommentJson.fromJson(asMap(json, 'json')),
        child: asList(json, 'child').map((e) {
          var list = e as List<dynamic>;
          return list.map((listE) => listE.toString()).toList();
        }).toList(),
        votes: asList(json, 'votes')
            .map((e) => NewVideosResponseModelItemVotesItem.fromJson(e))
            .toList(),
        ts: asInt(json, 'ts'),
        dist: asDouble(json, 'dist'),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'author': author,
        'link': link,
        'pa': pa,
        'pp': pp,
        'json': json.toJson(),
        'child': child.map((e) => e),
        'votes': votes.map((e) => e.toJson()),
        'ts': ts,
        'dist': dist,
      };
}

class VideoCommentJson {
  final String description;
  final String title;

  VideoCommentJson({
    this.description = "",
    this.title = "",
  });

  factory VideoCommentJson.fromJson(Map<String, dynamic>? json) =>
      VideoCommentJson(
        description: asString(json, 'description'),
        title: asString(json, 'title'),
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'title': title,
      };
}
