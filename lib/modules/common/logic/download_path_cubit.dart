import 'package:app_settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mediavault/utils/helpers/storage_box.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class DownloadPathState extends Equatable {
  final String path;
  final bool isLockEnabled;
  const DownloadPathState({
    required this.path,
    required this.isLockEnabled,
  });

  @override
  List<Object> get props => [path];
}

final class DownloadPathInitial extends DownloadPathState {
  const DownloadPathInitial(
      {required super.path, required super.isLockEnabled});
}

class DownloadPathCubit extends Cubit<DownloadPathState> {
  DownloadPathCubit()
      : super(DownloadPathInitial(
            path: '', isLockEnabled: Storagebox().isLockEnabled())) {
    loadPath();
  }

  loadPath() async {
    List<String>? paths = await Saf.getPersistedPermissionDirectories();
    if (paths?.isNotEmpty ?? false) {
      emit(DownloadPathState(
          path: paths?.first ?? 'n/a',
          isLockEnabled: Storagebox().isLockEnabled()));
    } else {
      emit(DownloadPathState(
          path: 'n/a', isLockEnabled: Storagebox().isLockEnabled()));
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
        emit(DownloadPathState(
            path: paths?.first ?? 'n/a',
            isLockEnabled: Storagebox().isLockEnabled()));
      } else {
        emit(DownloadPathState(
            path: 'n/a', isLockEnabled: Storagebox().isLockEnabled()));
      }
    } else {
      emit(DownloadPathState(
          path: 'n/a', isLockEnabled: Storagebox().isLockEnabled()));
    }
  }

  updateLock(bool value, BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    try {
      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please Authenticate to change lock status');
        // ···

        if (didAuthenticate) {
          Storagebox().updateLock(value);

          emit(DownloadPathInitial(
              path: state.path, isLockEnabled: Storagebox().isLockEnabled()));
          emit(DownloadPathState(
              path: state.path, isLockEnabled: Storagebox().isLockEnabled()));
        } else {
          // ignore: use_build_context_synchronously
          errorSnack('Failed to enable lock', context);
        }
      } else {
        AppSettings.openAppSettings(type: AppSettingsType.lockAndPassword);
      }
    } catch (e) {
      AppSettings.openAppSettings(type: AppSettingsType.lockAndPassword);
    }
  }

  errorSnack(msg, BuildContext context) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(msg ?? ''),
      ),
    );
  }
}
