import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediavault/modules/dashboard/logic/file_finder/file_finder_bloc.dart';

class DocumentTileWidget extends StatelessWidget {
  final IconData icon;
  final FileSystemEntity file;
  const DocumentTileWidget({
    Key? key,
    required this.file,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          context.read<FileFinderBloc>().add(OpenFileFinderEvent(file));
        },
        leading:  Icon(icon),
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
                    .add(RenameFileFinderEvent(file: file,context: context));
              },
              value: 1,
              child: const Text('Rename'),
            ),
            PopupMenuItem(
              onTap: () {
                context.read<FileFinderBloc>()
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
