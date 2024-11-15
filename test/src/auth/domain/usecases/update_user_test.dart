import 'package:dartz/dartz.dart';
import 'package:education_app/core/enum/update_user.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main(){
  late MockAuthRepo repo;
   late UpdateUser usecase;

   setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
   });

   test('should call [AuthRepo]', () async{
     when(() => repo.updateUser(
      action: any(named:'action'), userData: any<dynamic>(named: 'userData'))).
      thenAnswer((_) async => const Right(null));

        final result = await usecase(
          const UpdateUserParams(
            action: UpdateUserAction.email, 
            userData: 'test Email',),);

            expect(result, const Right<dynamic,void>(null));

            verify(() => repo.updateUser(
              action: UpdateUserAction.email, 
              userData: 'test Email',),).called(1);

              verifyNoMoreInteractions(repo);
   });
}
