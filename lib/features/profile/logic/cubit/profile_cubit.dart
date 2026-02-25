import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/profile_repo.dart';
import '../../data/models/profile_models.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial()) {
    getProfile();
  }

  ProfileResponse? profileData;

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final response = await profileRepo.getProfile();
      profileData = response;
      emit(ProfileLoaded(response));
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await profileRepo.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
