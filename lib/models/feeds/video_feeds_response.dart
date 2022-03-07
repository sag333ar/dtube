import 'package:dtube/models/feeds/safe_convert.dart';
import 'dart:convert';

// final jsonList = json.decode(jsonStr) as List;
// final list = jsonList.map((e) => VideoFeedResponseItemVideoFeedResponseItem.fromJson(e)).toList();

class VideoFeedResponseItemVideoFeedResponseItem {
  final String id;
  final String author;
  final String link;
  final VideoFeedResponseItemVideoFeedResponseItemJson json;
  final int ts;
  final double dist;

  VideoFeedResponseItemVideoFeedResponseItem({
    this.id = "",
    this.author = "",
    this.link = "",
    required this.json,
    this.ts = 0,
    this.dist = 0.0,
  });

  factory VideoFeedResponseItemVideoFeedResponseItem.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemVideoFeedResponseItem(
    id: asString(json, '_id'),
    author: asString(json, 'author'),
    link: asString(json, 'link'),
    json: VideoFeedResponseItemVideoFeedResponseItemJson.fromJson(asMap(json, 'json')),
    ts: asInt(json, 'ts'),
    dist: asDouble(json, 'dist'),
  );
}

class VideoFeedResponseItemVideoFeedResponseItemJson {
  final VideoFeedResponseItemVideoFeedResponseItemFiles files;
  final String title;
  final String desc;
  final String tag;
  final String dur;
  final String thumbnailUrlExternal;
  final String thumbnailUrl;
  final int hide;
  final int nsfw;
  final int oc;

  VideoFeedResponseItemVideoFeedResponseItemJson({
    required this.files,
    this.title = "",
    this.desc = "",
    this.tag = "",
    this.dur = "",
    this.thumbnailUrlExternal = "",
    this.thumbnailUrl = "",
    this.hide = 0,
    this.nsfw = 0,
    this.oc = 0,
  });

  factory VideoFeedResponseItemVideoFeedResponseItemJson.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemVideoFeedResponseItemJson(
    files: VideoFeedResponseItemVideoFeedResponseItemFiles.fromJson(asMap(json, 'files')),
    title: asString(json, 'title'),
    desc: asString(json, 'desc'),
    tag: asString(json, 'tag'),
    dur: asString(json, 'dur'),
    thumbnailUrlExternal: asString(json, 'thumbnailUrlExternal'),
    thumbnailUrl: asString(json, 'thumbnailUrl'),
    hide: asInt(json, 'hide'),
    nsfw: asInt(json, 'nsfw'),
    oc: asInt(json, 'oc'),
  );
}

class VideoFeedResponseItemVideoFeedResponseItemFiles {
  final String? youtube;
  final VideoFeedResponseItemVideoFeedResponseItemIpfs? ipfs;

  VideoFeedResponseItemVideoFeedResponseItemFiles({
    this.youtube = "",
    required this.ipfs,
  });

  factory VideoFeedResponseItemVideoFeedResponseItemFiles.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemVideoFeedResponseItemFiles(
    youtube: asString(json, 'youtube'),
    ipfs: VideoFeedResponseItemVideoFeedResponseItemIpfs.fromJson(asMap(json, 'ipfs')),
  );
}

class VideoFeedResponseItemVideoFeedResponseItemIpfs {
  final VideoFeedResponseItemVid vid;
  final VideoFeedResponseItemImg img;
  final String gw;

  VideoFeedResponseItemVideoFeedResponseItemIpfs({
    required this.vid,
    required this.img,
    this.gw = "",
  });

  factory VideoFeedResponseItemVideoFeedResponseItemIpfs.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemVideoFeedResponseItemIpfs(
    vid: VideoFeedResponseItemVid.fromJson(asMap(json, 'vid')),
    img: VideoFeedResponseItemImg.fromJson(asMap(json, 'img')),
    gw: asString(json, 'gw'),
  );

  Map<String, dynamic> toJson() => {
    'vid': vid.toJson(),
    'img': img.toJson(),
    'gw': gw,
  };
}

class VideoFeedResponseItemVid {
  final String src;

  VideoFeedResponseItemVid({
    this.src = "",
  });

  factory VideoFeedResponseItemVid.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemVid(
    src: asString(json, 'src'),
  );

  Map<String, dynamic> toJson() => {
    'src': src,
  };
}


class VideoFeedResponseItemImg {
  final String spr;

  VideoFeedResponseItemImg({
    this.spr = "",
  });

  factory VideoFeedResponseItemImg.fromJson(Map<String, dynamic>? json) => VideoFeedResponseItemImg(
    spr: asString(json, 'spr'),
  );

  Map<String, dynamic> toJson() => {
    'spr': spr,
  };
}

