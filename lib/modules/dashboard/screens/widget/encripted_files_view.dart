
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
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).indicatorColor,
            tabs: const [
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
          const Expanded(
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
