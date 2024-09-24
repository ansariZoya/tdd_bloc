

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn{}
class MockSignUp extends Mock implements SignUp{}
class MockUpdateUser extends Mock implements UpdateUser{}

class MockForgotPassword extends Mock implements ForgotPassword{}
void main(){
  late SignIn signIn;
  late SignUp signUp;
  late UpdateUser updateUser;
  late ForgotPassword forgotPassword;
  late AuthBloc authBloc;

  const tSigtnUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    updateUser = MockUpdateUser();
    forgotPassword = MockForgotPassword();
    authBloc = AuthBloc(signIn: signIn,
     signUp: signUp,
      forgotPassword: forgotPassword, updateUser: updateUser,);
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSigtnUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('Initial state should be [AuthInitial]', () {
    expect(authBloc.state, AuthInitial());
  });

final tServerFailure = ServerFailure(
  message: 'User not found', 
  statusCode: 'User may have deleted and can be other cause');
  group('signIn event', () {
    const tUser = LocalUser.empty();
    
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,SignedIn] when '
      'signedIn succeed',
      build: (){
        when(()=> signIn(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(email: tSignInParams.email, 
      password: tSignInParams.email)),
      expect: () =>  [
           AuthLoading(),
           const SignedIn(tUser),
      ],
      verify: (_){
        verify(()=> signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      }
    );

    blocTest<AuthBloc, AuthState>(
      'signIn event should emit [AuthLoading,AuthError] when signIn failed',
      build: (){
        when(()=> signIn(any())).thenAnswer((_) async =>Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(email: tSignInParams.email, 
      password: tSignInParams.password)),
      expect: () => [
        AuthLoading(),
        AuthError(tServerFailure.errorMessage)
      ],
       verify: (_){
        verify(()=> signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      }
    );
  });
  group('signedup', () {
    blocTest<AuthBloc, AuthState>(
      'signedUp event should emit [AuthLoading,SignedUpEvent] when '
      'SignedUp with new user succeed',
      build: (){
        when(()=> signUp(any())).thenAnswer((_) async=> const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
        email: tSigtnUpParams.email, 
        password: tSigtnUpParams.password,
         name: tSigtnUpParams.fullName)),
      expect: () => [
        AuthLoading(),
        const SignedUp(),
      ],
      verify: (_){
        verify(()=> signUp(tSigtnUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      }
    );
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,AutjError] when signedup fails',
      build: (){
        when(() => signUp(any())).thenAnswer((_) async=> Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
        email: tSigtnUpParams.email,
         password: tSigtnUpParams.password, 
         name: tSigtnUpParams.fullName)),
      expect: () => [
        AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_){
        verify(()=> signUp(tSigtnUpParams)).called(1);
        verifyNoMoreInteractions(signUp);}
    );
  });
  group('forgotpassword', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [ForgotPasswordSent] when password sent succeed',
      build: () {
        when(()=> forgotPassword(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add( const ForgotPasswordEvent('email')),
      expect: () => [
        AuthLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_){
        verify(()=> forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      }
    );
    blocTest<AuthBloc, AuthState>(
      'should  emit [AuthLoading,AuthError] when unsucceed forgotpassword',
      build: () {
        when(()=> forgotPassword(any())).thenAnswer((_) async=>Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add( const ForgotPasswordEvent( 'email')),
      expect: () => [
        AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
       verify: (_){
        verify(()=> forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      }
    );
  });
  group('updateUser', () {
    blocTest<AuthBloc, AuthState>(
      'emits [UserUpdated,AuthLoading] when MyEvent is added.',
      build: () {
        when(() => updateUser(any())).thenAnswer((_) async =>const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
           userData: tUpdateUserParams..userData,),
      ),
      expect: () => const[
        AuthLoading(),
        UserUpdated(),
      ],
      verify: (_){
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyZeroInteractions(updateUser);
      }
    );
  });
}