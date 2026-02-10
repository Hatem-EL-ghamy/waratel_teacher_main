import 'package:flutter/material.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeChangeBottomNavState extends HomeState {}

class HomeAdsLoading extends HomeState {}

class HomeAdsLoaded extends HomeState {
  final List<dynamic> ads; // dynamic for now or import Advertisement model if needed here, but usually state carries data
  HomeAdsLoaded(this.ads);
}

class HomeAdsError extends HomeState {
  final String error;
  HomeAdsError(this.error);
}

class HomeRecentCallsUpdated extends HomeState {}
