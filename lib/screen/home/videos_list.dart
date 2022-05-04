import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/screen/details/video_details.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideosList extends StatefulWidget {
  const VideosList({Key? key, required this.list}) : super(key: key);
  final List<NewVideosResponseModelItem> list;

  @override
  State<VideosList> createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  String getVideoThumbnailUrl(NewVideosResponseModelItem item) {
    if (item.jsonObject.thumbnailUrl.isNotEmpty) {
      return item.jsonObject.thumbnailUrl;
    } else if (item.jsonObject.thumbnailUrlExternal.isNotEmpty) {
      return item.jsonObject.thumbnailUrlExternal;
    } else if (item.jsonObject.files.youtube.isNotEmpty) {
      return "https://img.youtube.com/vi/${item.jsonObject.files.youtube}/0.jpg";
    } else {
      return "";
    }
  }

  Widget titleAndSubtitle(String title, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              // responseItems[index].jsonObject.title,
              style: Theme.of(context).textTheme.bodyText1),
          Text(subtitle,
              //'${responseItems[index].author}, DTC ${responseItems[index].dist}, ${responseItems[index].jsonObject.tag}',
              style: Theme.of(context).textTheme.bodyText2)
        ],
      ),
    );
  }

  Widget videoInfo(NewVideosResponseModelItem item) {
    var upvotes = item.votes.where((element) => element.vt > 0).length - 1;
    var dowvotes = item.votes.where((element) => element.vt < 0).length;
    var dateTime = timeago.format(DateTime.fromMillisecondsSinceEpoch(item.ts));
    var dtcValue = item.dist / 100.0;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(
                    'https://avalon.d.tube/image/avatar/${item.author}/small')
                .image,
          ),
          const SizedBox(width: 5),
          titleAndSubtitle(
            item.jsonObject.title,
            '${item.author}, DTC ${dtcValue.toStringAsFixed(2)} $dateTime ${upvotes > 0 ? '👍 $upvotes' : ''} ${dowvotes > 0 ? '👎 $dowvotes' : ''}',
          )
        ],
      ),
    );
  }

  Widget videoThumbnail(NewVideosResponseModelItem item) {
    return Stack(children: [
      SizedBox(
        height: 240,
        width: MediaQuery.of(context).size.width,
        child: FadeInImage.assetNetwork(
          placeholder: 'images/not_found_thumb.png',
          image: getVideoThumbnailUrl(item),
          imageErrorBuilder: (context, error, trace) {
            return Image.asset('images/not_found_thumb.png');
          },
          fit: BoxFit.fitWidth,
        ),
      ),
      Row(
        children: [
          const Spacer(),
          Image.asset(item.jsonObject.files.youtube.isEmpty
              ? 'images/ipfs.png'
              : 'images/yt.png'),
          const SizedBox(
            width: 5,
          )
        ],
      )
    ]);
  }

  Widget videoListTile(NewVideosResponseModelItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [videoThumbnail(item), videoInfo(item)],
      ),
      onTap: () {
        var screen = VideoDetailsScreen(item: item);
        var route = MaterialPageRoute(builder: (c) => screen);
        Navigator.of(context).push(route);
      },
    );
  }

  Widget listOfVideoTiles(List<NewVideosResponseModelItem> list) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return videoListTile(list[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: list.length);
  }

  @override
  Widget build(BuildContext context) {
    return listOfVideoTiles(widget.list);
  }
}
