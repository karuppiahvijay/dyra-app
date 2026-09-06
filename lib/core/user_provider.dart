import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String? selectedAvatar;
  final String? username;
  final bool isAuthenticated;

  UserState({
    this.selectedAvatar,
    this.username,
    this.isAuthenticated = false,
  });

  UserState copyWith({
    String? selectedAvatar,
    String? username,
    bool? isAuthenticated,
  }) {
    return UserState(
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      username: username ?? this.username,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  void selectAvatar(String avatarPath) {
    state = state.copyWith(selectedAvatar: avatarPath);
  }

  void login(String username) {
    state = state.copyWith(username: username, isAuthenticated: true);
  }

  void logout() {
    state = UserState();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
