import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchesRepository _matcheRepo;
  MatchingBloc(this._matcheRepo) : super(MatchesIntialState()) {
    on<GetRandomUsers>(
      (event, emit) async {
        emit(RandomProfileLoading());
        try {
          final userId = await UserRepository().getUser();
          final urew = await _matcheRepo.getRandomUserProfile(userId);
          debugPrint("Success getting users");
          emit(RandomProfileLoaded(
            urew,
          ));
        } catch (e) {
          debugPrint("Failed getting users :$e");
          emit(RandomProfileError(e.toString()));
        }
      },
    );

    on<GetRegionUsers>(
      (event, emit) async {
        emit(RegionprofilesLoading());
        try {
          final location = await _matcheRepo.getRecommendedProfiles();
          final interest =
              await _matcheRepo.getProfilesWithCommonInterestsAndGender(
                  await UserRepository().getUser());
          final ageUSers =
              await _matcheRepo.getProfilesWithCommonInterestsAndAge(
                  await UserRepository().getUser());
          emit(Regionprofiles(ageUSers,locationUsers: location, interest: interest));
        } catch (e) {
          debugPrint(e.toString());
          emit(RegionprofilesError(e.toString()));
        }
      },
    );
  }
}
