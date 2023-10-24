import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_update/in_app_update.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateInitial()) {
    on<CheckUpdateEvent>(_load);
    on<ImmediateUpdateEvent>(_immediatepdate);
    on<FlexibleUpdateEvent>(_flexibleUpdate);
    on<InstallUpdateEvent>(_install);
  }
  _load(CheckUpdateEvent event, Emitter<UpdateState> emit) async {
   try {
    // Check for updates.

      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

    // If an update is available, handle it accordingly.
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      emit(UpdateCheckComplete());
    }else{
      emit(UpdateFailure());
    }
   } catch (e) {
     emit(UpdateFailure());
   }
  }

  _flexibleUpdate(FlexibleUpdateEvent event, Emitter<UpdateState> emit) async {
   try {
    // Start a flexible update.
    // The update will now be downloaded in the background.
    final AppUpdateResult result= await InAppUpdate.startFlexibleUpdate();
     // Complete a flexible update.
     print(result.name);
     print(result);
     if (result.name== 'success') {
       emit(UpdateInflexible());
     }
    
    
     // The app will now be updated.
   } catch (e) {
     emit(UpdateFailure());
   }
  }
  _install(InstallUpdateEvent event, Emitter<UpdateState> emit)async{
     await InAppUpdate.completeFlexibleUpdate();
      emit(UpdateSuccess());
  }

  _immediatepdate(ImmediateUpdateEvent event, Emitter<UpdateState> emit) async {
   try {
    // Perform an immediate update.
     await InAppUpdate.performImmediateUpdate();
     // The app will now be updated and restarted.
     emit(UpdateSuccess());
   } catch (e) {
     emit(UpdateFailure());
   }
  }
}
