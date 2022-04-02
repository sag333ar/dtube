import 'package:dtube/models/new_videos_feed/safe_convert.dart';

class IpfsVideoDetails {
  final Vid vid;
  final Img img;
  final String gw;

  IpfsVideoDetails({
    required this.vid,
    required this.img,
    this.gw = "",
  });

  factory IpfsVideoDetails.fromJson(Map<String, dynamic>? json) =>
      IpfsVideoDetails(
        vid: Vid.fromJson(asMap(json, 'vid')),
        img: Img.fromJson(asMap(json, 'img')),
        gw: asString(json, 'gw'),
      );

  Map<String, dynamic> toJson() => {
        'vid': vid.toJson(),
        'img': img.toJson(),
        'gw': gw,
      };
}

class Vid {
  final String src;

  Vid({
    this.src = "",
  });

  factory Vid.fromJson(Map<String, dynamic>? json) => Vid(
        src: asString(json, 'src'),
      );

  Map<String, dynamic> toJson() => {
        'src': src,
      };
}

class Img {
  final String spr;

  Img({
    this.spr = "",
  });

  factory Img.fromJson(Map<String, dynamic>? json) => Img(
        spr: asString(json, 'spr'),
      );

  Map<String, dynamic> toJson() => {
        'spr': spr,
      };
}
