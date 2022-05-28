import 'package:badges/badges.dart';
import 'package:better_player/better_player.dart';
import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/models/new_videos_feed/video_comment.dart';
import 'package:dtube/screen/details/votes_container.dart';
import 'package:dtube/screen/home/home_screen.dart';
import 'package:dtube/server/dtube_app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart' as timeago;
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

  late List<NewVideosResponseModelItemVotesItem> votes;
  late List<VideoComment> comments;
  bool doWeHaveVotesInfo = false;
  bool doWeHaveComments = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.jsonObject.files.youtube.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.item.jsonObject.files.youtube,
        params: const YoutubePlayerParams(
          autoPlay: true,
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    } else if (widget.item.jsonObject.files.ipfs?.vid.src != null) {
      var gateway =
          widget.item.jsonObject.files.ipfs?.gw ?? 'https://player.d.tube';
      _videoUrl = '$gateway/ipfs/${widget.item.jsonObject.files.ipfs!.vid.src}';
    }
    loadVoteInfo();
  }

  List<VideoComment> refactorComments(NewVideosResponseModelItem item) {
    var arrayOfComments = item.videoComments;
    List<VideoComment> refactoredComments = [];
    List<String> ids = item.child.map((e) {
      return e.join("/");
    }).toList();
    refactoredComments += arrayOfComments.where((e) {
      return ids.contains(e.id);
    }).toList();
    refactoredComments.sort((a, b) {
      return a.ts < b.ts
          ? 1
          : a.ts > b.ts
              ? -1
              : 0;
    });
    while (refactoredComments.where((e) => e.isVisited == false).isNotEmpty) {
      var firstComment =
          refactoredComments.where((e) => e.isVisited == false).first;
      if (firstComment.isVisited) continue;
      var indexOfFirstElement = refactoredComments.indexOf(firstComment);
      if (firstComment.child.isNotEmpty) {
        List<String> childrenIds = firstComment.child.map((e) {
          return e.join("/");
        }).toList();
        List<VideoComment> children = arrayOfComments.where((e) {
          return childrenIds.contains(e.id);
        }).toList();
        children.sort((a, b) {
          return a.ts < b.ts
              ? 1
              : a.ts > b.ts
                  ? -1
                  : 0;
        });
        for (var e in children) {
          e.level = firstComment.level + 1;
        }
        refactoredComments.insertAll(indexOfFirstElement + 1, children);
      }
      firstComment.isVisited = true;
    }
    return refactoredComments;
  }

  Future<void> loadVoteInfo() async {
    var item = await DTubeAppData.loadContentDetails(widget.item.id);
    setState(() {
      votes = item.votes;
      comments = refactorComments(item);
      doWeHaveVotesInfo = true;
      doWeHaveComments = true;
    });
  }

  Widget _player() {
    return (widget.item.jsonObject.files.youtube.isNotEmpty)
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

  void showDownVotes() {
    var downVotes = votes.where((element) => element.vt <= 0).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return VotesContainer(
          title: 'Down votes',
          votes: downVotes,
        );
      },
    );
  }

  void showComments() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Comments'),
            ),
            body: ListView.separated(
              itemBuilder: (c, i) {
                var dateTime = timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(comments[i].ts));
                var author = comments[i].author;
                var upVotesCount =
                    comments[i].votes.where((e) => e.vt > 0).length;
                var downVotesCount =
                    comments[i].votes.where((e) => e.vt < 0).length;
                var dtc =
                    '${(comments[i].dist / 100.0).toStringAsFixed(2)} DTC';
                var subtitle =
                    '👤 $author · 🗓 $dateTime\n👍 $upVotesCount · 👎 $downVotesCount · $dtc';
                return ListTile(
                  contentPadding:
                      EdgeInsets.only(left: comments[i].level * 25 + 5),
                  leading: CircleAvatar(
                    backgroundImage: Image.network(
                            'https://avalon.d.tube/image/avatar/${comments[i].author}/small')
                        .image,
                  ),
                  title: Text(comments[i].json.description),
                  subtitle: Text(subtitle),
                );
              },
              separatorBuilder: (c, i) => const Divider(),
              itemCount: comments.length,
            ),
          ),
        );
      },
    );
  }

  void showUpVotes() {
    var upVotes = votes.where((element) => element.vt > 0).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return VotesContainer(
          title: 'Up votes',
          votes: upVotes,
        );
      },
    );
  }

  Widget _author() {
    return InkWell(
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
    var array = [
      _author(),
      const Spacer(),
      Text(
        '${(widget.item.dist / 100.0).toStringAsFixed(2)} DTC',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ];

    if (doWeHaveVotesInfo) {
      array += [
        IconButton(onPressed: showUpVotes, icon: upVoteButton),
        IconButton(onPressed: showDownVotes, icon: downVoteButton),
      ];
    }

    if (doWeHaveComments) {
      array += [
        IconButton(onPressed: showComments, icon: const Icon(Icons.comment)),
      ];
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: array,
      ),
    );
  }

  Widget _videoTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text(widget.item.jsonObject.title,
          style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget _videoDescription() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: MarkdownBody(
        data: widget.item.jsonObject.desc,
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
