import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignIn usecase;

  const tEmail = 'test email';
  const tPassword = 'test password';

  const tUser = LocalUser.empty();

  setUp((){
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });
  test('should return [LocalUser] from [AuthRepo]', 
  ()async {
    when(()=> repo.signIn(
      email:any(named: 'email'), 
      password:any(named: 'password'),),).thenAnswer
    ((_) async => const Right(tUser));

    final result = await usecase(
      const SignInParams(email: tEmail,
      password: tPassword,),);

      expect(result, equals(const Right<dynamic,LocalUser>(tUser)));
      verify(() => repo.signIn(
        email:tEmail, 
       password:tPassword,),).called(1);
      verifyNoMoreInteractions(repo);
    
  });
}
