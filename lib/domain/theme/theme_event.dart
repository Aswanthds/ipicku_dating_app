import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}


  class InitialThemeSetEvent extends ThemeEvent {}

  class ThemeSwitchEvent extends ThemeEvent {}
