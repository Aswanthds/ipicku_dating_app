import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'matches_data_event.dart';
part 'matches_data_state.dart';

class MatchesDataBloc extends Bloc<MatchesDataEvent, MatchesDataState> {
  final MatchesRepository _matcheRepo;
  MatchesDataBloc(this._matcheRepo) : super(MatchesDataInitial()) {
    on<MatchesLoadingEvent>((event, emit) async {
      emit(MatchesListLoading());
      try {
        final userId = await UserRepository().getUser();
        List<Map<String, dynamic>> matchedList =
            await _matcheRepo.getMatchedList(userId);

        emit(MatchesListLoaded(userProfile: matchedList));
        debugPrint("data : ${matchedList[0]['name']}");
      } catch (e) {
        debugPrint("Error :$e");
        emit(const MatchesListLoadError(
            errorMessage: 'Error occured white fetching profiles'));
      }
    });
    on<SelectedListLoadingEvent>((event, emit) async {
      emit(SelectedListLoading());
      try {
        final userId = await UserRepository().getUser();

        List<Map<String, dynamic>> selectedList =
            await _matcheRepo.getSelectedList(userId);
        emit(SelectedListLoaded(userProfile: selectedList));
        debugPrint("data : ${selectedList[0]['name']}");
      } catch (e) {
        debugPrint("Error :$e");
        emit(const SelectedListLoadError(
            errorMessage: 'Error occured white fetching profiles'));
      }
    });
    on<AddUserAsAPick>(
      (event, emit) async {
        emit(DatePickedLoadingState());
        try {
          _matcheRepo.selectUser(
              await UserRepository().getUser(), event.selectedUserId);
          debugPrint(event.selectedUserId);
          emit(DatePickedState());
        } catch (e) {
          debugPrint("Error :$e");
          emit(const DatePickedErrorState('Error occured white fetching profiles'));
        }
      },
    );

    on<MutualListLoadingEvent>(
      (event, emit) async {
        emit(MutualListLoading());
        try {
          final userList = await _matcheRepo.getMutualList();
          debugPrint(userList[0]['name']);
          emit(MutualListLoaded(userProfile: userList));
        } catch (e) {
          debugPrint("Error :$e");
          emit(const MutualListLoadError(
              errorMessage: 'Error occured white fetching profiles'));
        }
      },
    );
  }
}
