import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediavault/utils/helpers/file_helper.dart';
import 'package:mediavault/utils/services/notification_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'file_finder_event.dart';
part 'file_finder_state.dart';

class FileFinderBloc extends Bloc<FileFinderEvent, FileFinderState> {
  FileFinderBloc() : super(FileFinderInitial()) {
    on<LoadFileFinderEvent>(_loadFiles);
    on<DeleteFileFinderEvent>(_deleteFile);
    on<OpenFileFinderEvent>(_openFile);
    on<RenameFileFinderEvent>(_renameFile);
    on<DownloadFileFinderEvent>(_downloadFiles);
    on<ShareFileFinderEvent>(_shareFile);
  }

  _loadFiles(FileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
      await load(event, emit);
    } catch (e) {
      emit(const FileFinderFailure());
    }
  }
  _shareFile(ShareFileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
     await Share.shareXFiles([XFile(event.file.path)],text: 'This file is protected by Media Vault');
      // await load(event, emit);
    } catch (e) {
      // emit(const FileFinderFailure());
    }
  }
  _downloadFiles(DownloadFileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
     await FileHelper().saveFileToDownloads(File(event.file.path));
    } catch (e) {
      emit(const FileFinderFailure());
    }
  }

  _openFile(OpenFileFinderEvent event, Emitter<FileFinderState> emit) async {
    if (kDebugMode) {
      print(event.file.path);
    }
    File oFile =
        await FileHelper().decryptFileRwa(event.file, 'dotenv.env[key32bit]');
    if (kDebugMode) {
      print(oFile.path);
    }
    OpenFilex.open(oFile.path);
  }

  _deleteFile(
      DeleteFileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
      await event.file.delete();
       NotificationApi().showNotification(
        title: 'File deleted',
        body: 'The ${event.file.path.split('/').last} file has been deleted from the application',
        payload: '',
        id: 0);
      await load(event, emit);
    } catch (e) {
      emit(const FileFinderFailure());
    }
  }

  _renameFile(
      RenameFileFinderEvent event, Emitter<FileFinderState> emit) async {
    rename(path) async {
      await event.file.rename(path);
    }

    error(msg) {
  ScaffoldMessenger.maybeOf(event.context)?.showSnackBar(
     SnackBar(
      content: Text(msg??''),
    ),
  );
}


    try {
      List list = event.file.path.split('/');
      String oldName = list.last.toString().split('.').first;
      list.removeLast();

      String name = '';
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Rename'),
        content: TextFormField(
          initialValue: oldName,
          onChanged: (value) {
            name = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                String path =
                    '${list.join('/')}/$name.${event.file.path.split('.').last}';
                if (FileHelper().fileExists(path)) {
                  error('File already exists');
                } else {
                  if (name != '') {
                    rename(path);
                  }
                }

                Navigator.pop(event.context);
              },
              child: const Text('Rename'))
        ],
      );

      await showAdaptiveDialog(
        context: event.context,
        builder: (context) => alertDialog,
      );
      await Future.delayed(const Duration(seconds: 1));
      await load(event, emit);
    } catch (e) {
      emit(const FileFinderFailure());
    }
  }

  load(event, Emitter<FileFinderState> emit) async {
    emit(FileFinderLoading());
    final appDirectory = await getApplicationDocumentsDirectory();

    final imageDirectory = Directory('${appDirectory.path}/image');

    final videoDirectory = Directory('${appDirectory.path}/video');
    final docDirectory = Directory('${appDirectory.path}/any');

    List<FileSystemEntity> imagefiles = [];
    List<FileSystemEntity> videofiles = [];
    List<FileSystemEntity> docfiles = [];

    try {
      imagefiles = await imageDirectory
          .list()
          .where((entity) => entity is File)
          .toList();
    } catch (e) {
      imagefiles = [];
    }

    try {
      videofiles = await videoDirectory
          .list()
          .where((entity) => entity is File)
          .toList();
    } catch (e) {
      videofiles = [];
    }

    try {
      docfiles =
          await docDirectory.list().where((entity) => entity is File).toList();
    } catch (e) {
      docfiles = [];
    }

    emit(
      FileFinderLoaded(
        imagefiles: imagefiles,
        videofiles: videofiles,
        docfiles: docfiles,
      ),
    );
  }
}
