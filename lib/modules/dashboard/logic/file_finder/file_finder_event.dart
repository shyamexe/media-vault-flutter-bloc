// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_finder_bloc.dart';

sealed class FileFinderEvent extends Equatable {
  const FileFinderEvent();

  @override
  List<Object> get props => [];
}

class LoadFileFinderEvent extends FileFinderEvent {
  const LoadFileFinderEvent();

  @override
  List<Object> get props => [];
}
class OpenFileFinderEvent extends FileFinderEvent {
  final FileSystemEntity file;
  const OpenFileFinderEvent(
    this.file,
  );

  @override
  List<Object> get props => [file];
}

class DeleteFileFinderEvent extends FileFinderEvent {
  final FileSystemEntity file;
  const DeleteFileFinderEvent({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}
class DownloadFileFinderEvent extends FileFinderEvent {
  final FileSystemEntity file;
  const DownloadFileFinderEvent({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}
class RenameFileFinderEvent extends FileFinderEvent {
  final FileSystemEntity file;
  final BuildContext context;
  const RenameFileFinderEvent({
    required this.file,
    required this.context,
  });

  @override
  List<Object> get props => [file,context];
}
