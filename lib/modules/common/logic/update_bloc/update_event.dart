part of 'update_bloc.dart';

sealed class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}
class CheckUpdateEvent extends UpdateEvent {
  const CheckUpdateEvent();

  @override
  List<Object> get props => [];
}
class InstallUpdateEvent extends UpdateEvent {
  const InstallUpdateEvent();

  @override
  List<Object> get props => [];
}
class FlexibleUpdateEvent extends UpdateEvent {
  const FlexibleUpdateEvent();

  @override
  List<Object> get props => [];
}
class ImmediateUpdateEvent extends UpdateEvent {
  const ImmediateUpdateEvent();

  @override
  List<Object> get props => [];
}