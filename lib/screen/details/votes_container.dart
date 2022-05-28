import 'package:dtube/models/new_videos_feed/new_videos_feed.dart';
import 'package:dtube/screen/details/list_of_votes.dart';
import 'package:flutter/material.dart';

class VotesContainer extends StatefulWidget {
  const VotesContainer({Key? key, required this.votes, required this.title})
      : super(key: key);
  final List<NewVideosResponseModelItemVotesItem> votes;
  final String title;

  @override
  State<VotesContainer> createState() => _VotesContainerState();
}

class _VotesContainerState extends State<VotesContainer> {
  var isUpVoteSelected = false;
  var isDownVoteSelected = false;
  var isListSelected = true;

  var voteSliderValue = 20.0;
  var tipSliderValue = 20.0;

  Widget _child() {
    var voteSlider = Slider(
      value: voteSliderValue,
      max: 100,
      min: 1,
      divisions: 100,
      label: "${voteSliderValue.round().toString()} %",
      activeColor: isUpVoteSelected ? Colors.green : Colors.red,
      onChanged: (newVal) {
        setState(() {
          voteSliderValue = newVal;
        });
      },
    );
    var tipSlider = Slider(
      value: tipSliderValue,
      max: 100,
      min: 0,
      divisions: 100,
      label: "${tipSliderValue.round().toString()} %",
      onChanged: (newVal) {
        setState(() {
          tipSliderValue = newVal;
        });
      },
    );
    var voteButton =
        ElevatedButton(onPressed: () {}, child: const Text('Vote'));
    if (isUpVoteSelected) {
      return Container(
        margin: const EdgeInsets.only(top: 55),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Set up vote value'),
            voteSlider,
            const SizedBox(height: 30),
            const Text('Set tip value'),
            tipSlider,
            const SizedBox(height: 30),
            voteButton,
          ],
        ),
      );
    } else if (isDownVoteSelected) {
      return Container(
        margin: const EdgeInsets.only(top: 55),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Set up vote value'),
            voteSlider,
            const SizedBox(height: 10),
            voteButton,
          ],
        ),
      );
    } else {
      return ListOfVotes(votes: widget.votes);
    }
  }

  List<Widget> actions() {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            isUpVoteSelected = false;
            isDownVoteSelected = false;
            isListSelected = true;
          });
        },
        icon: Icon(
          Icons.list,
          color: isListSelected ? Colors.black : Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            isUpVoteSelected = true;
            isDownVoteSelected = false;
            isListSelected = false;
          });
        },
        icon: Icon(
          Icons.thumb_up_sharp,
          color: isUpVoteSelected ? Colors.black : Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            isUpVoteSelected = false;
            isDownVoteSelected = true;
            isListSelected = false;
          });
        },
        icon: Icon(
          Icons.thumb_down_sharp,
          color: isDownVoteSelected ? Colors.black : Colors.white,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          SizedBox(
            height: 55,
            child: AppBar(
              title: Text(isListSelected
                  ? widget.title
                  : isUpVoteSelected
                      ? 'Up vote content'
                      : 'Down vote content'),
              actions: actions(),
            ),
          ),
          _child(),
        ],
      ),
    );
  }
}
