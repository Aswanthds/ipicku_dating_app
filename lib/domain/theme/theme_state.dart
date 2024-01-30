import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  ThemeData get themeData;
}

class ThemeIntial extends ThemeState{
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  ThemeData get themeData => throw UnimplementedError();
}
class LightTheme extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.light();
  
  @override
 
  List<Object?> get props => [themeData];
}

class DarkTheme extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.dark();
  
  @override
 
  List<Object?> get props => [themeData];
}
