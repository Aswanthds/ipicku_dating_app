import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchesRepository _matcheRepo;
  MatchingBloc(this._matcheRepo) : super(MatchesIntialState()) {
    // on<LoadListsEvent>((event, emit) async {
    //   emit(MatchesLoadingState());
    //   try {
    //     final data = await UserRepository().getUserData();
    //     Stream<QuerySnapshot> matchedList =
    //         _matcheRepo.getMatchedList(event.userId);

    //     Stream<QuerySnapshot> selectedList =
    //         _matcheRepo.getSelectedList(event.userId);
    //     emit(MatchesLoadedState(matchedList, selectedList));
    //     debugPrint("data : ${data!.gender}");
    //   } catch (e) {
    //     debugPrint("Error :$e");
    //     emit(MatchesLoadedFailed('Error occured white fetching profiles'));
    //   }
    // });

    on<AcceptUserEvent>(
      (event, emit) {
        emit(MatchesLoadingState());
        try {
          _matcheRepo.selectUser(event.currentUser, event.selectedUser);
          Stream<QuerySnapshot> matchedList =
              _matcheRepo.getMatchedList(event.currentUser);

          Stream<QuerySnapshot> selectedList =
              _matcheRepo.getSelectedList(event.currentUser);
          emit(MatchesLoadedState(matchedList, selectedList));
        } catch (e) {
          debugPrint("Error :$e");
          emit(const MatchesLoadedFailed('Error occured white fetching profiles'));
        }
      },
    );
    on<GetRandomUsers>(
      (event, emit) async {
        emit(RandomProfileLoading());
        try {
          final userId = await UserRepository().getUser();
          final urew = await _matcheRepo.getRandomUserProfile(userId);

          emit(RandomProfileLoaded(urew));
        } catch (e) {
          emit(RandomProfileError(e.toString()));
        }
      },
    );

    on<GetRegionUsers>(
      (event, emit) async {
        emit(RandomProfileLoading());
        try {
          final userProfile = await _matcheRepo.getRecommendedProfiles();
          emit(Regionprofiles(userProfile: userProfile));
        } catch (e) {
          debugPrint(e.toString());
          emit(RegionprofilesError(e.toString()));
        }
      },
    );
  }
}
