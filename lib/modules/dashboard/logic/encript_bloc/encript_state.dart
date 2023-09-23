// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'encript_bloc.dart';

sealed class EncriptState extends Equatable {
  const EncriptState();

  @override
  List<Object?> get props => [];
}

final class EncriptInitial extends EncriptState {}

class EncriptLoading extends EncriptState {
  final String? title;
  const EncriptLoading({
    required this.title,
  });

  @override
  List<Object?> get props => [title];
}

class EncriptLoaded extends EncriptState {
  // final FilePickerResult? files;
}

final class EncriptFailure extends EncriptState {}
