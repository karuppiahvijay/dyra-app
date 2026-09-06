import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivationStatus { idle, processing, success, error }

class ActivationState {
  final int currentStep;
  final ActivationStatus status;
  final String? message;

  ActivationState({
    this.currentStep = 0,
    this.status = ActivationStatus.idle,
    this.message,
  });

  ActivationState copyWith({
    int? currentStep,
    ActivationStatus? status,
    String? message,
  }) {
    return ActivationState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class ActivationNotifier extends StateNotifier<ActivationState> {
  ActivationNotifier() : super(ActivationState());

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> startActivation() async {
    state = state.copyWith(status: ActivationStatus.processing, message: 'Verifying credentials...');
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(message: 'Activating modules...');
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(status: ActivationStatus.success, message: 'Platform Activated Successfully!');
  }

  void reset() {
    state = ActivationState();
  }
}

final activationProvider = StateNotifierProvider<ActivationNotifier, ActivationState>((ref) {
  return ActivationNotifier();
});
