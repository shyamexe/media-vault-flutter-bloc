import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediavault/utils/helpers/file_helper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

part 'file_finder_event.dart';
part 'file_finder_state.dart';

class FileFinderBloc extends Bloc<FileFinderEvent, FileFinderState> {
  FileFinderBloc() : super(FileFinderInitial()) {
    on<LoadFileFinderEvent>(_loadFiles);
    on<DeleteFileFinderEvent>(_deleteFile);
    on<OpenFileFinderEvent>(_openFile);
  }

  _loadFiles(FileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
      emit(FileFinderLoading());
      final appDirectory = await getApplicationDocumentsDirectory();

      final imageDirectory = Directory('${appDirectory.path}/image');
      print(imageDirectory);

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
        docfiles = await docDirectory
            .list()
            .where((entity) => entity is File)
            .toList();
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
    } catch (e) {
      emit(FileFinderFailure());
    }
  }

  _openFile(OpenFileFinderEvent event, Emitter<FileFinderState> emit) async {
    print(event.file.path);
    File oFile = await FileHelper()
        .decryptFileRwa(event.file,dotenv.env['key32bit']??'');
        print(oFile.path);
    OpenFilex.open(oFile.path);
  }

  _deleteFile(
      DeleteFileFinderEvent event, Emitter<FileFinderState> emit) async {
    try {
      await event.file.delete();
      emit(FileFinderLoading());
      final appDirectory = await getApplicationDocumentsDirectory();

      final imageDirectory = Directory('${appDirectory.path}/image');
      print(imageDirectory);

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
        docfiles = await docDirectory
            .list()
            .where((entity) => entity is File)
            .toList();
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
    } catch (e) {
      emit(FileFinderFailure());
    }
  }
}
