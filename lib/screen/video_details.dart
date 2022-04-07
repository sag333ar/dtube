import 'package:better_player/better_player.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoDetailsScreen extends StatefulWidget {
  const VideoDetailsScreen({Key? key, required this.item}) : super(key: key);
  // final String videoId;
  final NewVideosResponseModelItem item;

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  late YoutubePlayerController _controller;
  late String? _videoUrl;

  @override
  void initState() {
    super.initState();
    if (widget.item.json.files.youtube.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.item.json.files.youtube,
        params: const YoutubePlayerParams(
          autoPlay: true,
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    } else if (widget.item.json.files.ipfs?.vid.src != null) {
      var gateway = widget.item.json.files.ipfs?.gw ?? 'https://player.d.tube';
      _videoUrl = '$gateway/ipfs/${widget.item.json.files.ipfs!.vid.src}';
    }
  }

  Widget _player() {
    return (widget.item.json.files.youtube.isNotEmpty)
        ? YoutubePlayerIFrame(
            controller: _controller,
            aspectRatio: 16 / 9,
          )
        : (_videoUrl != null)
            ? BetterPlayer.network(
                _videoUrl!,
                betterPlayerConfiguration: const BetterPlayerConfiguration(
                  aspectRatio: 16 / 9,
                ),
              )
            : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _player(),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(widget.item.json.title,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: MarkdownBody(
                data: widget.item.json.desc,
                onTapLink: (text, href, title) async {
                  if (href != null) {
                    await launch(href);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
