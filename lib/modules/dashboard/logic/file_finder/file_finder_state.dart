// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_finder_bloc.dart';

sealed class FileFinderState extends Equatable {
  const FileFinderState();

  @override
  List<Object> get props => [];
}

final class FileFinderInitial extends FileFinderState {}

final class FileFinderLoading extends FileFinderState {}

class FileFinderLoaded extends FileFinderState {
  final List<FileSystemEntity> imagefiles;
  final List<FileSystemEntity> videofiles;
  final List<FileSystemEntity> docfiles;
  FileFinderLoaded({
    required this.imagefiles,
    required this.videofiles,
    required this.docfiles,
  });
  @override
  List<Object> get props => [imagefiles,videofiles,docfiles];
}

final class FileFinderFailure extends FileFinderState {}
