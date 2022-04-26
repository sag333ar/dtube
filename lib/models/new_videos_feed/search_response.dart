import 'dart:convert';

import 'package:dtube/models/new_videos_feed/safe_convert.dart';

class SearchResponse {
  final SearchResponseHits hits;

  SearchResponse({
    required this.hits,
  });

  factory SearchResponse.fromJson(Map<String, dynamic>? json) => SearchResponse(
        hits: SearchResponseHits.fromJson(asMap(json, 'hits')),
      );

  factory SearchResponse.fromJsonString(String jsonString) {
    var value = SearchResponseHits.fromJson(json.decode(jsonString));
    return SearchResponse(hits: value);
  }

  Map<String, dynamic> toJson() => {
        'hits': hits.toJson(),
      };
}

class SearchResponseHits {
  final List<SearchResponseHitItem> hits;

  SearchResponseHits({
    required this.hits,
  });

  factory SearchResponseHits.fromJson(Map<String, dynamic>? json) {
    var value = (json?['hits']['hits'] as List<dynamic>)
        .map((e) => SearchResponseHitItem.fromJson(e))
        .toList();
    return SearchResponseHits(
      hits: value,
    );
  }

  Map<String, dynamic> toJson() => {
        'hits': hits.map((e) => e.toJson()),
      };
}

class SearchResponseHitItem {
  final SearchResponseHitItemSource source;

  SearchResponseHitItem({
    required this.source,
  });

  factory SearchResponseHitItem.fromJson(Map<String, dynamic>? json) {
    var source = SearchResponseHitItemSource.fromJson(asMap(json, '_source'));
    return SearchResponseHitItem(
      source: source,
    );
  }

  Map<String, dynamic> toJson() => {
        '_source': source.toJson(),
      };
}

class SearchResponseHitItemSource {
  final SearchResponseHitItemSourceJson json;
  final String name;

  SearchResponseHitItemSource({
    required this.json,
    this.name = "",
  });

  factory SearchResponseHitItemSource.fromJson(Map<String, dynamic>? json) {
    var name = asString(json, 'name');
    return SearchResponseHitItemSource(
      json: SearchResponseHitItemSourceJson.fromJson(asMap(json, 'json')),
      name: name,
    );
  }

  Map<String, dynamic> toJson() => {
        'json': json.toJson(),
        'name': name,
      };
}

class SearchResponseHitItemSourceJson {
  final SearchResponseHitItemSourceJsonProfile profile;

  SearchResponseHitItemSourceJson({
    required this.profile,
  });

  factory SearchResponseHitItemSourceJson.fromJson(
          Map<String, dynamic>? json) =>
      SearchResponseHitItemSourceJson(
        profile: SearchResponseHitItemSourceJsonProfile.fromJson(
            asMap(json, 'profile')),
      );

  Map<String, dynamic> toJson() => {
        'profile': profile.toJson(),
      };
}

class SearchResponseHitItemSourceJsonProfile {
  final String about;
  final String avatar;
  final String blurt;
  final String coverImage;
  final String hive;
  final String location;
  final String steem;
  final String website;

  SearchResponseHitItemSourceJsonProfile({
    this.about = "",
    this.avatar = "",
    this.blurt = "",
    this.coverImage = "",
    this.hive = "",
    this.location = "",
    this.steem = "",
    this.website = "",
  });

  factory SearchResponseHitItemSourceJsonProfile.fromJson(
          Map<String, dynamic>? json) =>
      SearchResponseHitItemSourceJsonProfile(
        about: asString(json, 'about'),
        avatar: asString(json, 'avatar'),
        blurt: asString(json, 'blurt'),
        coverImage: asString(json, 'cover_image'),
        hive: asString(json, 'hive'),
        location: asString(json, 'location'),
        steem: asString(json, 'steem'),
        website: asString(json, 'website'),
      );

  Map<String, dynamic> toJson() => {
        'about': about,
        'avatar': avatar,
        'blurt': blurt,
        'cover_image': coverImage,
        'hive': hive,
        'location': location,
        'steem': steem,
        'website': website,
      };
}
