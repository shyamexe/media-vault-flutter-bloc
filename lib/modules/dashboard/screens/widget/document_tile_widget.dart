import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediavault/modules/dashboard/logic/file_finder/file_finder_bloc.dart';
import 'package:mediavault/utils/helpers/text_helper.dart';

class DocumentTileWidget extends StatelessWidget {
  final IconData icon;
  final FileSystemEntity file;
  const DocumentTileWidget({Key? key, required this.file, required this.icon})
      : super(key: key);


Widget switchWithInt(String? value){
    switch(value){
 
      case '(video)' :
      return Icon(Icons.movie_creation_outlined);
 
      case '(image)' :
      return Icon(Icons.image_outlined);
 
      case '(audio)':
      return Icon(Icons.audiotrack_rounded);
 
 
      default :
      return Icon(Icons.insert_drive_file_outlined);
 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          context.read<FileFinderBloc>().add(OpenFileFinderEvent(file));
        },
        // leading: Text(TextHelper(). checkFile(file.path.split('.').last)??'n'),
        leading: switchWithInt(TextHelper(). checkFile(file.path.split('.').last)),
        title: Text(file.path.split('/').last),
        trailing: PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              onTap: () {
                context.read<FileFinderBloc>().add(OpenFileFinderEvent(file));
              },
              value: 1,
              child: const Text('Open'),
            ),
            PopupMenuItem(
              onTap: () {
                context
                    .read<FileFinderBloc>()
                    .add(ShareFileFinderEvent(file: file));
              },
              value: 1,
              child: const Text('Share'),
            ),
            PopupMenuItem(
              onTap: () {
                context
                    .read<FileFinderBloc>()
                    .add(RenameFileFinderEvent(file: file, context: context));
              },
              value: 1,
              child: const Text('Rename'),
            ),
            PopupMenuItem(
              onTap: () {
                context
                    .read<FileFinderBloc>()
                    .add(DownloadFileFinderEvent(file: file));
              },
              value: 2,
              child: const Text('Download'),
            ),
            PopupMenuItem(
              onTap: () {
                context
                    .read<FileFinderBloc>()
                    .add(DeleteFileFinderEvent(file: file));
              },
              value: 3,
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
