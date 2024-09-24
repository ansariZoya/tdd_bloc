import 'dart:convert';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enum/update_user.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockUser extends Mock implements User{
   String _uid = 'Test uid';
   @override 
   String get uid => _uid;
   set uid (String value){
    if(_uid!= value) _uid = value;
   }
}
class MockUserCredential extends Mock implements UserCredential{
  MockUserCredential([User? user]) : _user = user;
  User? _user;
  @override 
  User? get user => _user;
  set user (User? value){
    if(_user != value) _user = value;
  }
}
class MockAuthCredential extends Mock implements AuthCredential{}
void main(){
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late DocumentReference<DataMap> documentReference;
  late UserCredential userCredential;
  late MockUser mockuser;
const tUser = LocalUserModel.empty();
  setUpAll(()async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    documentReference = cloudStoreClient.collection('user').doc();
    await documentReference.set(
      tUser.copyWith(uid:documentReference.id).toMap(),
    );
    mockuser = MockUser()..uid=documentReference.id;
    userCredential = MockUserCredential(mockuser);
    dataSource = AuthRemoteDataSourceImpl(authClient: authClient,
    cloudStoreClient: cloudStoreClient, dbClient: dbClient,);
    
    when(()=> authClient.currentUser).thenReturn(mockuser);

  });
 
  const tPassword = 'Test password';
  const tFullName = 'Test fullName';
  const tEmail = 'testemail@email.com';

  final tFirebaseAuthException = FirebaseAuthException(code: 'user not found',
  message: 'There is no information of the corresponding identifire');
  group('forgot password', () {
    test('should complete successfully when no [Exception is thrown]', 
    () async {
      when(()=> authClient.sendPasswordResetEmail(email: any(named:'email'))).
      thenAnswer((_) async => Future.value);

      final call =  dataSource.forgotPassword(tEmail);

      expect(call, completes);
      verify(()=> authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw [ServerException] when [FirebaseException] is thrown',
     ()async {
      when(()=> authClient.sendPasswordResetEmail(email: any(named: 'email'))).
      thenThrow(tFirebaseAuthException);

      final call = dataSource.forgotPassword;
      expect(()=> call(tEmail) ,throwsA(isA<ServerException>()));
      verify(()=> authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);

    });
  });
  group('signIn', () {
    test('should return [LocalUserModel] when there is no [Exception]', 
    () async{
      when(()=> authClient.signInWithEmailAndPassword(
        email: any(named:'email'), 
        password: any(named:'password'))).thenAnswer(
          (_)async => userCredential);

          final result =await dataSource.signIn(email: tEmail, password: tPassword);
          expect(result.uid, userCredential.user!.uid);
          expect(result.points, 0);
          verify(()=> authClient.signInWithEmailAndPassword(
            email: tEmail, password: tPassword));
            verifyNoMoreInteractions(authClient);
    });
    test('should throw [ServerException]when user is null after signin ',

     ()async {
      final emptyUserCredential = MockUserCredential();
      when(()=> authClient.signInWithEmailAndPassword(email: any(named: 'email'), 
      password: any(named: 'password'))).thenAnswer((_) async=> emptyUserCredential);

      final call = dataSource.signIn;
      expect(call(email: tEmail,password: tPassword),throwsA(isA<ServerException>()));
      verify(()=> authClient.signInWithEmailAndPassword(email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(authClient);
     });
     test('should throw [serverException] when there is [FirebaseException]', 
     ()async {
       when(()=> authClient.signInWithEmailAndPassword(email: 
       any(named: 'email'), password: any(named: 'password')))
       .thenThrow(tFirebaseAuthException);
       final call = dataSource.signIn;
       expect(call(email: tEmail,password: tPassword), throwsA(isA<ServerException>()));
       verify(()=> authClient.signInWithEmailAndPassword(email: tEmail, password: tPassword)).called(1);
       verifyNoMoreInteractions(authClient);
     });
  });
  group('signUp', () { 
   test('should complete successfull when no [Exception]is thrown',
    () async{
     when(()=> authClient.createUserWithEmailAndPassword(
      email: any(named: 'email'), password: any(named: 'password')),).thenAnswer(
        (_) async => userCredential);
        when(()=> userCredential.user?.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value());
          when(()=> userCredential.user?.updatePhotoURL(any())).thenAnswer(
            (_)  async=> Future.value());

        final call = dataSource.signUp(email: tEmail, password: tPassword, 
        fullname: tFullName);
        expect(call, completes);
        verify(()=> authClient.createUserWithEmailAndPassword(email: tEmail, 
        password: tPassword)).called(1);
        await untilCalled(()=> userCredential.user?.updateDisplayName(any()));
          await untilCalled(()=> userCredential.user?.updatePhotoURL(any()));
          verify(()=> userCredential.user?.updateDisplayName(tFullName)).called(1);
          verify(()=> userCredential.user?.updatePhotoURL(kDefaultAvatar)).called(1);
          verifyNoMoreInteractions(authClient);
   });
   test('should throw [serverException] when[FirebaseException] is thrown',
    ()async {
     when(()=> authClient.createUserWithEmailAndPassword(
      email: any(named: 'email'),
       password: any(named: 'password'))).thenThrow(tFirebaseAuthException);

       final call =  dataSource.signUp(email: tEmail, 
       password: tPassword, 
       fullname: tFullName);

       expect(call, throwsA(isA<ServerException>()));
       verify(()=> authClient.createUserWithEmailAndPassword(
        email: tEmail, password: tPassword)).called(1);
        verifyNoMoreInteractions(authClient);

   });
  });

  group('updateUser', () {
    setUp(() {
      
     // registerFallbackValue(MockAuthCredential());
    });
       test('should update user dispalyName Successfully when '
       'no[Exception] thrown'
       , () async {
           when(() => mockuser.updateDisplayName(any())).thenAnswer(
            (_) async => Future.value(),);

            await dataSource.updateUser(
              action: UpdateUserAction.displayName, 
              userData: tFullName,);

              verify(()=> mockuser.updateDisplayName(tFullName)).called(1);

              verifyNever(()=> mockuser.updatePhotoURL(any()));
              verifyNever(()=> mockuser.updateEmail(any()));
              verifyNever(()=> mockuser.updatePassword(any()));

              final userData = 
            await   cloudStoreClient.collection('users').doc(documentReference.id).get();

            expect(userData.data()!['fullName'],'Test Fullname');
       });
       test('should update user Email successflly when '
         'no[Exception thrown]'
       , ()async {
          when(() => mockuser.updateEmail(any())).thenAnswer(
            (_)  async => Future.value(),);

            await dataSource.updateUser(
              action: UpdateUserAction.email, 
              userData: tEmail,);

              verify(()=> mockuser.updateEmail(tEmail)).called(1);
              verifyNever(() => mockuser.updateDisplayName(any()));
              verifyNever(()=> mockuser.updatePassword(any()));
              verifyNever(()=> mockuser.updatePhotoURL(any()));

              final user = 
              await cloudStoreClient.collection('users').doc(mockuser.uid).get();

              expect(user.data()!['email'],tEmail);
       });

       test('should update user bio ssuccessfully when '
       '[noException] is thrown', () async{
          const newBio = 'new Bio';

          await dataSource.updateUser
          (action: UpdateUserAction.bio
          , userData: newBio,);

          final user = 
          await cloudStoreClient.collection('users').doc(documentReference.id).get();

          expect(user.data()!['bio'],newBio);

          verifyNever(() => mockuser.updateDisplayName(any()));
          verifyNever(() => mockuser.updateEmail(any()));
          verifyNever(()=> mockuser.updatePassword(any()));
          verifyNever(() => mockuser.updatePhotoURL(any()));
       });

       test('should update user password successfully when '
       '[noexception] thrown', () async{
           when(() => mockuser.updatePassword(any())).thenAnswer(
            (_) async => Future.value,);
       
       when(() => mockuser.reauthenticateWithCredential(any())).thenAnswer
       ((_)  async => userCredential);

       when(() => mockuser.email).thenReturn(tEmail);

       await dataSource.updateUser(
        action: UpdateUserAction.password, 
        userData: jsonEncode({
          'oldpassword' : 'oldpassword',
          'newpassword' : tPassword,
        }),);

        verify(() => mockuser.updatePassword(tPassword)).called(1);
         verifyNever(() => mockuser.updateDisplayName(any()));
          verifyNever(() => mockuser.updateEmail(any()));
          verifyNever(() => mockuser.updatePhotoURL(any()));

          final user = await 
             cloudStoreClient.collection('users').doc(
              documentReference.id
             ).get();

             expect(user.data()!['Password'], 'newpassword');

       });

       test('should update user profile pic successfully when '
       '[noException] is thrown', () async{
        final newProfilePic = File('assets/images/onBoarding_background.png');
            when(() => mockuser.updatePhotoURL(any())).thenAnswer(
              (_) async => Future.value(),);
              await dataSource.updateUser(
                action: UpdateUserAction.profilePic, 
                userData: newProfilePic);

                verify(() => mockuser.updatePhotoURL(any())).called(1);
                verifyNever(() => mockuser.updateDisplayName(any()));
          verifyNever(() => mockuser.updateEmail(any()));
          verifyNever(() => mockuser.updatePassword(any()));

          expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
          

       });
  });
}