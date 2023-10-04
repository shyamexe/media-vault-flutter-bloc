// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'encript_bloc.dart';

sealed class EncriptEvent extends Equatable {
  const EncriptEvent();

  @override
  List<Object> get props => [];
}

class EncryptFilesEvent extends EncriptEvent {
  final FileType type;
  final BuildContext context;
  const EncryptFilesEvent({
    required this.type,
    required this.context
  });

  @override
  List<Object> get props => [type,context];

}
