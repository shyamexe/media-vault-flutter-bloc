import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class DownloadPathState extends Equatable {
  final String path;
  const DownloadPathState({required this.path});

  @override
  List<Object> get props => [path];
}

final class DownloadPathInitial extends DownloadPathState {
  const DownloadPathInitial({required super.path});
}

class DownloadPathCubit extends Cubit<DownloadPathState> {
  DownloadPathCubit() : super(const DownloadPathInitial(path: '')) {
    loadPath();
  }

  loadPath() async {
    List<String>? paths = await Saf.getPersistedPermissionDirectories();
    if (paths?.isNotEmpty ?? false) {
      emit(DownloadPathState(path: paths?.first ?? 'n/a'));
    } else {
      emit(const DownloadPathState(path: 'n/a'));
    }
  }

  updatePath() async {
    await Saf.releasePersistedPermissions();
    List<String>? paths = await Saf.getPersistedPermissionDirectories();

    Permission.storage.request();
    Saf saf = Saf('/Download/');
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: true);

    if (isGranted != null && isGranted) {
      paths = await Saf.getPersistedPermissionDirectories();

      if (paths?.isNotEmpty ?? false) {
        emit(DownloadPathState(path: paths?.first ?? 'n/a'));
      } else {
        emit(const DownloadPathState(path: 'n/a'));
      }
    } else {
      emit(const DownloadPathState(path: 'n/a'));
    }
  }
}
