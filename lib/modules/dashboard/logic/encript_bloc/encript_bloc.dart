import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediavault/utils/helpers/file_helper.dart';

part 'encript_event.dart';
part 'encript_state.dart';

class EncriptBloc extends Bloc<EncriptEvent, EncriptState> {
  EncriptBloc() : super(EncriptInitial()) {
    on<EncryptFilesEvent>((event, emit) async {
      try {
        emit(const EncriptLoading(title: null));
        FilePickerResult? result =
            await FileHelper().openFiles(type: event.type);
        emit(const EncriptLoading(title: 'files Loaded'));
        if (result != null) {
          for (var i = 0; i < result.files.length; i++) {
            final File tempFile = File(result.files[i].path!);
            await FileHelper().encryptFileRaw(
                tempFile,
                'dotenv.env[key32bit] ?? ' '',
                event.type.name,
                result.files[i].name);
            emit(EncriptLoading(
                title:
                    'file encripted: ${result.files[i].name} ($i/${result.files.length})'));
          }
          emit(EncriptLoaded());
        } else {
          emit(EncriptFailure());
        }
      } catch (e) {
        emit(EncriptFailure());
      }
    });
  }
}
