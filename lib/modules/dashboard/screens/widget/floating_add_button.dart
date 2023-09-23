import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:mediavault/modules/dashboard/logic/encript_bloc/encript_bloc.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.small,
          shape: const CircleBorder(),
        ),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.videocam_rounded),
            onPressed: ()async {
              context.read<EncriptBloc>().add(const EncryptFilesEvent(type: FileType.video));
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.image_rounded),
            onPressed: ()async {
              context.read<EncriptBloc>().add(const EncryptFilesEvent(type: FileType.image));

            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.insert_drive_file_rounded),
            onPressed: ()async {
              context.read<EncriptBloc>().add(const EncryptFilesEvent(type: FileType.any));

            },
          ),
        ],
      );
  }
}