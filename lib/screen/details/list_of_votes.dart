import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListOfVotes extends StatefulWidget {
  const ListOfVotes({Key? key, required this.votes}) : super(key: key);
  final List<NewVideosResponseModelItemVotesItem> votes;
  @override
  State<ListOfVotes> createState() => _ListOfVotesState();
}

class _ListOfVotesState extends State<ListOfVotes> {
  Widget _votesList() {
    if (widget.votes.isEmpty) {
      return const Center(
        child: Text('Nothing to show.'),
      );
    }
    widget.votes.sort((a, b) => a.vt > b.vt
        ? -1
        : a.vt < b.vt
            ? 1
            : 0);
    var formatter = NumberFormat.compact();
    return Container(
      margin: const EdgeInsets.only(top: 55),
      child: ListView.separated(
        itemBuilder: (c, i) {
          var dateTime = timeago
              .format(DateTime.fromMillisecondsSinceEpoch(widget.votes[i].ts));
          return ListTile(
            contentPadding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
            leading: CircleAvatar(
              backgroundImage: Image.network(
                      'https://avalon.d.tube/image/avatar/${widget.votes[i].u}/small')
                  .image,
            ),
            title: Text(widget.votes[i].u,
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(
                '${formatter.format(widget.votes[i].vt)} votes\n$dateTime'),
            trailing: Text(
              '${(widget.votes[i].claimable / 100.0).toStringAsFixed(2)} DTC',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
        separatorBuilder: (c, i) => const Divider(height: 0),
        itemCount: widget.votes.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _votesList();
  }
}
