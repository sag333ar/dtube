import 'package:badges/badges.dart';
import 'package:better_player/better_player.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
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

  Widget votesList(List<NewVideosResponseModelItemVotesItem> votes) {
    var formatter = NumberFormat.compact();
    return Container(
      margin: const EdgeInsets.only(top: 55),
      child: ListView.separated(
        itemBuilder: (c, i) {
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            leading: CircleAvatar(
              backgroundImage: Image.network(
                      'https://avalon.d.tube/image/avatar/${votes[i].u}/small')
                  .image,
            ),
            title:
                Text(votes[i].u, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(formatter.format(votes[i].vt)),
          );
        },
        separatorBuilder: (c, i) => const Divider(height: 0),
        itemCount: votes.length,
      ),
    );
  }

  void showDownVotes() {
    var downVotes =
        widget.item.votes.where((element) => element.vt <= 0).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Stack(
            children: [
              SizedBox(
                height: 55,
                child: AppBar(
                  title: const Text('Down voted by following users'),
                ),
              ),
              votesList(downVotes),
            ],
          ),
        );
      },
    );
  }

  void showUpVotes() {
    var upVotes = widget.item.votes.where((element) => element.vt > 0).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Stack(
            children: [
              SizedBox(
                height: 55,
                child: AppBar(
                  title: const Text('Up voted by following users'),
                ),
              ),
              votesList(upVotes),
            ],
          ),
        );
      },
    );
  }

  Widget _videoAuthorInfo() {
    var upvotes =
        widget.item.votes.where((element) => element.vt > 0).length - 1;
    var dowvotes = widget.item.votes.where((element) => element.vt < 0).length;
    var upVoteButton = upvotes > 0
        ? Badge(
            badgeContent: Text('$upvotes'),
            position: const BadgePosition(top: -15, end: -15),
            child: const Icon(Icons.thumb_up_sharp),
          )
        : const Icon(Icons.thumb_up_sharp);
    var downVoteButton = dowvotes > 0
        ? Badge(
            badgeContent: Text('$dowvotes'),
            position: const BadgePosition(top: -15, end: -15),
            child: const Icon(Icons.thumb_down_sharp),
          )
        : const Icon(Icons.thumb_down_sharp);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: Image.network(
                          'https://avalon.d.tube/image/avatar/${widget.item.author}/small')
                      .image,
                ),
                const SizedBox(width: 5),
                Text(widget.item.author,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            onTap: () {
              var screen = HomeWidget(
                  title: widget.item.author,
                  path: 'blog/${widget.item.author}',
                  shouldShowDrawer: false);
              var route = MaterialPageRoute(builder: (c) => screen);
              Navigator.of(context).push(route);
            },
          ),
          const Spacer(),
          IconButton(onPressed: showUpVotes, icon: upVoteButton),
          IconButton(onPressed: showDownVotes, icon: downVoteButton),
        ],
      ),
    );
  }

  Widget _videoTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text(widget.item.json.title,
          style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget _videoDescription() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: MarkdownBody(
        data: widget.item.json.desc,
        onTapLink: (text, href, title) async {
          if (href != null) {
            await launch(href);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _player(),
            _videoAuthorInfo(),
            _videoTitle(),
            _videoDescription(),
          ],
        ),
      ),
    );
  }
}
