import 'package:flutter/material.dart';

@immutable
class ProfileState {}

class ProfileStateEmpty extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateFailure extends ProfileState {}

class ProfileStateSuccess extends ProfileState {}
