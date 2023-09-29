part of 'bio_auth_bloc.dart';

sealed class BioAuthEvent extends Equatable {
  const BioAuthEvent();

  @override
  List<Object> get props => [];
}

class CheckBioAuthEvent extends BioAuthEvent {
  const CheckBioAuthEvent();
  @override
  List<Object> get props => [];
}
class RemoveBioAuthEvent extends BioAuthEvent {
  final DateTime time;
  const RemoveBioAuthEvent({required this.time});
  @override
  List<Object> get props => [time];
}
class ResumedBioAuthEvent extends BioAuthEvent {
  const ResumedBioAuthEvent();
  @override
  List<Object> get props => [];
}
