// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bio_auth_bloc.dart';

sealed class BioAuthState extends Equatable {
  const BioAuthState();

  @override
  List<Object> get props => [];
}

final class BioAuthInitial extends BioAuthState {}

final class BioAuthLoading extends BioAuthState {}

final class BioAuthSuccess extends BioAuthState {}
class BioAuthSuspended extends BioAuthState {
  final DateTime time;
  const BioAuthSuspended({
    required this.time,
  });

  @override
  List<Object> get props => [time];
}

final class BioAuthFailed extends BioAuthState {}
