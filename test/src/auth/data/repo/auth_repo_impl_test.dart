import 'package:dartz/dartz.dart';
import 'package:education_app/core/enum/update_user.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/data/repo/auth_repo_impl.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tEmail = 'test email';
  const tPassword = 'test password';
  const tFullName = 'testfullname';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New Password';

  const tUser = LocalUserModel.empty();
  group('forgotpassword', () {
    test('should return [void] when call to the datasource successfull',
        () async {
      when(() => remoteDataSource.forgotPassword(any())).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repoImpl.forgotPassword(tEmail);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
    test(
        'should return [ServerFailure] when call to datasource is  '
        'unsuccessfull', () async {
      when(() => remoteDataSource.forgotPassword(any())).thenThrow(
        const ServerException(
          message: 'Unable to find account',
          statusCode: 404,
        ),
      );
      final result = await repoImpl.forgotPassword(tEmail);

      expect(
        result,
        equals(
          Left<dynamic, void>(
            ServerFailure(
              message: 'Unable to find account',
              statusCode: 404,
            ),
          ),
        ),
      );

      verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  group('signIn', () {
    test(
        'should return [LocalUser] when call to the remote  source is '
        'succccessfull', () async {
      when(
        () => remoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => tUser,
      );

      final result = await repoImpl.signIn(email: tEmail, password: tPassword);

      expect(result, equals(const Right<dynamic, LocalUser>(tUser)));

      verify(
        () => remoteDataSource.signIn(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call to the data souurce is '
        'unsuccessfull', () async {
      when(
        () => remoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const ServerException(message: 'Unable to find', statusCode: 404),
      );

      final result = await repoImpl.signIn(email: tEmail, password: tPassword);

      expect(
        result,
        equals(
          Left<dynamic, void>(
            ServerFailure(
              message: 'Unable to find',
              statusCode: 404,
            ),
          ),
        ),
      );

      verify(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('signUp', () {
    test('should return[void]when call to the source is success', () async {
      when(() => remoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullname: any(named: 'fullName')))
          .thenAnswer((_) async => Future.value());

      final result = await repoImpl.signUp(
          email: tEmail, fullname: tFullName, password: tPassword);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => remoteDataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullname: tFullName,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return [ServerFailure] when call to source is unsuccessfull',
        () async {
      when(
        () => remoteDataSource.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullname: any(
            named: 'fullName',
          ),
        ),
      ).thenThrow(
        const ServerException(message: 'Unable to find', statusCode: 404),
      );

      final result = await repoImpl.signUp(
        email: tEmail,
        fullname: tFullName,
        password: tPassword,
      );

      expect(
        result,
        equals(
          Left<dynamic, void>(
            ServerFailure(message: 'Unable to find', statusCode: 404),
          ),
        ),
      );

      verify(
        () => remoteDataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullname: tFullName,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  group('updateUser', () {
    test('should return [void] if call to source is successfull', () async {
      when(
        () => remoteDataSource.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.updateUser(
        action: tUpdateAction,
        userData: tUserData,
      );

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => remoteDataSource.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call to the source is '
        'unsuccessfull', () async {
      when(
        () => remoteDataSource.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(
            named: 'userData',
          ),
        ),
      ).thenThrow(
        const ServerException(
            message: 'Unable to find', statusCode: 404,),
      );

      final result = await repoImpl.updateUser(
        action: tUpdateAction,
        userData: tUserData,
      );

      expect(
        result,
        equals(
          Left<dynamic, void>(
            ServerFailure(
              message: 'Unable to find',
              statusCode: 404,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
