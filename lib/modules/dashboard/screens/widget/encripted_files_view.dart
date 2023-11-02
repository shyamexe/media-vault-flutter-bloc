
import 'package:flutter/material.dart';

import 'doc_list.dart';
import 'image_list.dart';
import 'video_list.dart';

class EncriptedFilesView extends StatelessWidget {
  const EncriptedFilesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: 'Images',
              ),
              Tab(
                text: 'Videos',
              ),
              Tab(
                text: 'Documents',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ImageList(),
                VideoList(),
                DocList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
