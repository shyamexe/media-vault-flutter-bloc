import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mediavault/utils/helpers/storage_box.dart';

part 'bio_auth_event.dart';
part 'bio_auth_state.dart';

class BioAuthBloc extends Bloc<BioAuthEvent, BioAuthState> {
  BioAuthBloc() : super(BioAuthInitial()) {
    on<CheckBioAuthEvent>(
      Storagebox().isLockEnabled() ? _loadBio : _avoidBio,
    );
    on<RemoveBioAuthEvent>(
      Storagebox().isLockEnabled() ? _clearBio : _avoidBio,
    );
    on<ResumedBioAuthEvent>(
      Storagebox().isLockEnabled() ? _resumeBio : _avoidBio,
    );
  }

  _avoidBio(event, Emitter<BioAuthState> emit) {
    emit(BioAuthSuccess());
  }

  _clearBio(RemoveBioAuthEvent event, Emitter<BioAuthState> emit) async {
    if (state is BioAuthSuccess) {
      emit(BioAuthSuspended(time: event.time));
    }
  }

  _resumeBio(ResumedBioAuthEvent event, Emitter<BioAuthState> emit) async {
    if (state is BioAuthSuspended) {
    if ( DateTime.now().difference((state as BioAuthSuspended).time).inSeconds.abs() >=
            Storagebox().getLockTime()) {
      try {
        emit(BioAuthLoading());
        final LocalAuthentication auth = LocalAuthentication();
        final bool canAuthenticateWithBiometrics =
            await auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        if (canAuthenticate) {
          try {
            final bool didAuthenticate = await auth.authenticate(
                localizedReason: 'Please authenticate to show Documents');
            // ···

            if (didAuthenticate) {
              emit(BioAuthSuccess());
            } else {
              emit(BioAuthFailed());
            }
          } on PlatformException {
            // ...
            emit(BioAuthFailed());
          }
        } else {
          emit(BioAuthSuccess());
        }
      } catch (e) {
        emit(BioAuthFailed());
      }
    }}
  }

  _loadBio(CheckBioAuthEvent event, Emitter<BioAuthState> emit) async {
    try {
      emit(BioAuthLoading());
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to show Documents');
          // ···

          if (didAuthenticate) {
            emit(BioAuthSuccess());
          } else {
            emit(BioAuthFailed());
          }
        } on PlatformException {
          // ...
          emit(BioAuthFailed());
        }
      } else {
        emit(BioAuthSuccess());
      }
    } catch (e) {
      emit(BioAuthFailed());
    }
  }
}
