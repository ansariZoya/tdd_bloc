

import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  const tEmail = 'test email';
 const tPassword = 'test password';
const  tFullName = 'test fullName';


  setUp(() {
    repo = MockAuthRepo();
    usecase= SignUp(repo);
  });

  test('should call [AuthRepo]', () 
  async{
    when(() => repo.signUp(
      email: any(named: 'email'), 
      fullname: any(named: 'fullName'), 
      password: any(named: 'password'),),).thenAnswer(
      (_)  async=> const Right(null),);

      final result = await usecase(const SignUpParams(
        email: tEmail, 
        password: tPassword, 
        fullName: tFullName,),);

        expect(result, const Right<dynamic,void>(null));

       verify(
        () => repo.signUp(
          email: tEmail,
          password: tPassword,
          fullname: tFullName,
        ),
      ).called(1);
        verifyNoMoreInteractions(repo);
    
  });

  
}
