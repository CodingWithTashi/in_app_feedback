import 'package:flutter/foundation.dart';

enum SubmittedState { initial, submitting, submitted }

class FeedbackNotifier extends ChangeNotifier {
  SubmittedState state = SubmittedState.initial;

  updateState({required SubmittedState newState}) {
    state = newState;
    notifyListeners();
  }
}
