import 'package:flutter/material.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
// Add more states as feature grows (e.g., ProfileLoading, ProfileLoaded)
