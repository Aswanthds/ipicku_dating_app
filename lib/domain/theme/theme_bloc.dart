import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/repositories/theme.dart';
import 'package:ipicku_dating_app/domain/theme/theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(AppTheme.lightTheme) {
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await isDark();
      if (hasDarkTheme) {
        emit(AppTheme.darkTheme);
      } else {
        emit(AppTheme.lightTheme);
      }
    });
    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == AppTheme.darkTheme;
      emit(isDark ? AppTheme.lightTheme : AppTheme.darkTheme);
      setTheme(isDark);
    });
  }
}
