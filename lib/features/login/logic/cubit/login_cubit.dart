import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  // Future: Add GlobalKey<FormState> for validation

  bool isPasswordObscure = true;
  IconData suffixIcon = Icons.visibility_off;

  void changePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    suffixIcon = isPasswordObscure ? Icons.visibility_off : Icons.visibility;
    emit(LoginInitial()); // Re-emit initial to rebuild UI safely or better yet a specific state
    // In a real app, you might want a specific state for UI changes like this to avoid full re-builds if using BlocConsumer
    // For simplicity here, we rely on the BlocConsumer to listen/build. 
    // Wait, emitting LoginInitial might be confusing if we were in another state.
    // Better practice: separate state or just emit a specific 'ChangeVisibility' state?
    // For now, let's keep it simple as requested, or just re-emit the current state type if possible.
    // Actually, `emit` updates the state. If we just want to update UI without changing logic state (loading/success/error),
    // we can use a `LoginChangePasswordVisibility` state if we wanted to be very granular.
    // But standard practice often mixes UI state.
    // Let's stick to the requested structure.
    
    // To trigger rebuild for visibility, we need a new state instance.
    emit(LoginInitial()); 
  }

  void login() async {
    emit(LoginLoading());
    try {
      // Simulation of API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Validation logic validation would go here or before
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
           emit(LoginSuccess('تم تسجيل الدخول بنجاح'));
      } else {
           emit(LoginError('يرجى ملء جميع الحقول'));
      }

    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
