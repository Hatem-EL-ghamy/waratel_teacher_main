import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/repos.dart';
import '../../data/models/models.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit(this.loginRepo) : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;
  IconData suffixIcon = Icons.visibility_off;

  void changePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    suffixIcon = isPasswordObscure ? Icons.visibility_off : Icons.visibility;
    emit(LoginPasswordVisibilityChanged());
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());
    try {
      final LoginResponse response = await loginRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.status) {
        emit(LoginSuccess(response.message, response));
      } else {
        emit(LoginError(response.message));
      }
    } catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
