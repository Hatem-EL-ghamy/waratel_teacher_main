import 'package:flutter/material.dart';

@immutable
abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordFilterChangedState extends RecordState {
  final bool showCompletedCalls;
  RecordFilterChangedState(this.showCompletedCalls);
}
