part of 'matching_bloc.dart';

sealed class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object> get props => [];
}

class GetRandomUsers extends MatchingEvent {}

class GetRegionUsers extends MatchingEvent {
  final double radius;

  const GetRegionUsers({required this.radius});
}
