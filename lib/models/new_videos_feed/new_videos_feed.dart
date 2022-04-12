import 'dart:convert';

import 'package:dtube/models/new_videos_feed/ipfs_video_details.dart';
import 'package:dtube/models/new_videos_feed/safe_convert.dart';

// final jsonList = json.decode(jsonStr) as List;
// final list = jsonList.map((e) => NewVideosResponseModelItem.fromJson(e)).toList();

List<NewVideosResponseModelItem> decodeStringOfVideos(String jsonString) {
  final jsonList = json.decode(jsonString) as List;
  final list =
      jsonList.map((e) => NewVideosResponseModelItem.fromJson(e)).toList();
  return list;
}

class NewVideosResponseModelItem {
  final String id;
  final String author;
  final String link;
  final NewVideosResponseModelItemJson jsonObject;
  final List<NewVideosResponseModelItemVotesItem> votes;
  final int ts;
  final double dist;

  NewVideosResponseModelItem({
    this.id = "",
    this.author = "",
    this.link = "",
    required this.jsonObject,
    required this.votes,
    this.ts = 0,
    this.dist = 0.0,
  });

  factory NewVideosResponseModelItem.fromJson(Map<String, dynamic>? json) =>
      NewVideosResponseModelItem(
        id: asString(json, '_id'),
        author: asString(json, 'author'),
        link: asString(json, 'link'),
        jsonObject:
            NewVideosResponseModelItemJson.fromJson(asMap(json, 'json')),
        votes: asList(json, 'votes')
            .map((e) => NewVideosResponseModelItemVotesItem.fromJson(e))
            .toList(),
        ts: asInt(json, 'ts'),
        dist: asDouble(json, 'dist'),
      );

  factory NewVideosResponseModelItem.fromJsonString(String string) =>
      NewVideosResponseModelItem.fromJson(json.decode(string));

  Map<String, dynamic> toJson() => {
        '_id': id,
        'author': author,
        'link': link,
        'json': jsonObject.toJson(),
        'votes': votes.map((e) => e.toJson()),
        'ts': ts,
        'dist': dist,
      };
}

class NewVideosResponseModelItemJson {
  final NewVideosResponseModelItemFiles files;
  final String title;
  final String desc;
  final String dur;
  final String tag;
  final String thumbnailUrlExternal;
  final String thumbnailUrl;
  final int hide;
  final int nsfw;
  final int oc;

  NewVideosResponseModelItemJson({
    required this.files,
    this.title = "",
    this.desc = "",
    this.dur = "",
    this.tag = "",
    this.thumbnailUrlExternal = "",
    this.thumbnailUrl = "",
    this.hide = 0,
    this.nsfw = 0,
    this.oc = 0,
  });

  factory NewVideosResponseModelItemJson.fromJson(Map<String, dynamic>? json) =>
      NewVideosResponseModelItemJson(
        files: NewVideosResponseModelItemFiles.fromJson(asMap(json, 'files')),
        title: asString(json, 'title'),
        desc: asString(json, 'desc'),
        dur: asString(json, 'dur'),
        tag: asString(json, 'tag'),
        thumbnailUrlExternal: asString(json, 'thumbnailUrlExternal'),
        thumbnailUrl: asString(json, 'thumbnailUrl'),
        hide: asInt(json, 'hide'),
        nsfw: asInt(json, 'nsfw'),
        oc: asInt(json, 'oc'),
      );

  Map<String, dynamic> toJson() => {
        'files': files.toJson(),
        'title': title,
        'desc': desc,
        'dur': dur,
        'tag': tag,
        'thumbnailUrlExternal': thumbnailUrlExternal,
        'thumbnailUrl': thumbnailUrl,
        'hide': hide,
        'nsfw': nsfw,
        'oc': oc,
      };
}

class NewVideosResponseModelItemFiles {
  final String youtube;
  final IpfsVideoDetails? ipfs;

  NewVideosResponseModelItemFiles({
    this.youtube = "",
    this.ipfs,
  });

  factory NewVideosResponseModelItemFiles.fromJson(
          Map<String, dynamic>? json) =>
      NewVideosResponseModelItemFiles(
        youtube: asString(json, 'youtube'),
        ipfs: IpfsVideoDetails.fromJson(json?['ipfs']),
      );

  Map<String, dynamic> toJson() => {
        'youtube': youtube,
      };
}

class NewVideosResponseModelItemVotesItem {
  final String u;
  final int ts;
  final int vt;
  final String tag;
  final double gross;
  final double claimable;

  NewVideosResponseModelItemVotesItem({
    this.u = "",
    this.ts = 0,
    this.vt = 0,
    this.tag = "",
    this.gross = 0.0,
    this.claimable = 0.0,
  });

  factory NewVideosResponseModelItemVotesItem.fromJson(
          Map<String, dynamic>? json) =>
      NewVideosResponseModelItemVotesItem(
        u: asString(json, 'u'),
        ts: asInt(json, 'ts'),
        vt: asInt(json, 'vt'),
        tag: asString(json, 'tag'),
        gross: asDouble(json, 'gross'),
        claimable: asDouble(json, 'claimable'),
      );

  Map<String, dynamic> toJson() => {
        'u': u,
        'ts': ts,
        'vt': vt,
        'tag': tag,
        'gross': gross,
        'claimable': claimable,
      };
}
