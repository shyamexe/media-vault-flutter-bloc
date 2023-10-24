part of 'update_bloc.dart';

sealed class UpdateState extends Equatable {
  const UpdateState();
  
  @override
  List<Object> get props => [];
}

final class UpdateInitial extends UpdateState {}
final class UpdateLoading extends UpdateState {}
final class UpdateCheckComplete extends UpdateState {}
final class UpdateInflexible extends UpdateState {}
final class UpdateSuccess extends UpdateState {}
final class UpdateFailure extends UpdateState {}
