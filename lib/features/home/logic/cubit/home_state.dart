import 'package:flutter/material.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeChangeBottomNavState extends HomeState {}

class HomeRecentCallsUpdated extends HomeState {}
