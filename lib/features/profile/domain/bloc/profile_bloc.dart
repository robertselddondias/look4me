import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/modules/auth/models/user_model.dart';
import '../repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final user = await _repository.getUserProfile();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: 'Erro ao carregar perfil: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      await _repository.updateUserProfile(event.user);

      // Emitir estado de sucesso
      emit(ProfileUpdated(user: event.user));

      // Recarregar perfil atualizado
      final updatedUser = await _repository.getUserProfile();
      emit(ProfileLoaded(user: updatedUser));
    } catch (e) {
      emit(ProfileError(message: 'Erro ao atualizar perfil: ${e.toString()}'));
    }
  }
}
