import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      try {
        User? user = await _authRepository.signUp(event.email, event.password, event.username);
        if (user != null) {
          emit(Authenticated(user, event.username));
        } else {
          emit(AuthError("Sign up failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignInEvent>((event, emit) async {
      try {
        User? user = await _authRepository.signIn(event.email, event.password);
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user!.uid).get();
        String username = userDoc['username'];
        if (user != null) {
          emit(Authenticated(user, username));
        } else {
          emit(AuthError("Sign in failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      await _authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
