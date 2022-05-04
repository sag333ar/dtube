import 'dart:developer';

import 'package:dtube/models/new_videos_feed/search_response.dart';
import 'package:dtube/screen/home/home_screen.dart';
import 'package:dtube/server/dtube_app_data.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchTerm = '';
  var isLoading = false;
  List<SearchResponseHitItem> hits = [];

  void doSearch() async {
    setState(() {
      isLoading = true;
    });
    try {
      SearchResponse response = await DTubeAppData.doSearch(searchTerm);
      setState(() {
        hits = response.hits.hits;
        isLoading = false;
      });
    } catch (e) {
      log('Error occurred - ${e.toString()}');
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _body() {
    if (hits.isEmpty) {
      return const Center(child: Text('No records found'));
    }
    return ListView.separated(
      itemBuilder: (c, i) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: Image.network(
                    'https://avalon.d.tube/image/avatar/${hits[i].source.name}/small')
                .image,
          ),
          title: Text(hits[i].source.name),
          onTap: () {
            var screen = HomeWidget(
                title: hits[i].source.name,
                path: 'blog/${hits[i].source.name}',
                shouldShowDrawer: false);
            var route = MaterialPageRoute(builder: (c) => screen);
            Navigator.of(context).push(route);
          },
        );
      },
      separatorBuilder: (c, i) => const Divider(),
      itemCount: hits.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            // icon: Icon(Icons.search),
            hintText: '🔍 Enter search text here.',
            // label: Text('Search'),
          ),
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
        ),
      ),
      body: _body(),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (searchTerm.trim().isNotEmpty &&
                    searchTerm.trim().length >= 3) {
                  doSearch();
                }
              },
              child: const Icon(Icons.search),
            ),
    );
  }
}
