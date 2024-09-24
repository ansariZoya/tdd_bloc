import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enum/update_user.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();
  Future<void> forgotPassword(String email);
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String password,
    required String fullname,
  });
  Future<void> updateUser({
    required UpdateUserAction action,
     required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
          email: email, password: password,
          );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
            message: 'please try again later', statusCode: 'Unknown Error');
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 'Unknown error');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullname,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(fullname);
      await userCred.user?.updatePhotoURL(kDefaultAvatar);
      // await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
   @override
  Future<void> updateUser(
    {required UpdateUserAction action, 
  required dynamic userData,}) async {
    try {
      switch (action) {
        case UpdateUserAction.email: 
        await _authClient.currentUser?.updateEmail(userData as String);
        await _updateUserData({'email' : userData});
        break;

        case UpdateUserAction.displayName:
        await _authClient.currentUser?.updateDisplayName(userData as String);
        await _updateUserData({'displayName': userData});
        break;
        case UpdateUserAction.profilePic:
        final ref = _dbClient
        .ref()
        .child('profile_pics/${_authClient.currentUser?.uid}');
        await ref.putFile(userData as File);
        final url = await ref.getDownloadURL();
        await _authClient.currentUser?.updatePhotoURL(url);
        await _updateUserData({'profilePic':url});
         break;
        case UpdateUserAction.password:
        if(_authClient.currentUser?.email==null){
          throw const ServerException
          (message: 'User does not exist', 
          statusCode: 'Insufficient Permission',);
        }

        final newData = jsonDecode(userData as String) as DataMap;
        await _authClient.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: _authClient.currentUser!.email!, 
            password: newData['OldPassword'] as String,
            ),
          );

          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
          break;
          case UpdateUserAction.bio:
          await _updateUserData({'bio':userData});
            
          
          
      }
      
    }on FirebaseException catch (e){
      throw ServerException(
        message: e.message?? 'Error Occured' ,
        statusCode: e.code,);
    }
     catch (e,s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(), 
        statusCode: '505',);
    }
  }



  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullname: user.displayName ?? '',
            profilePic: user.photoURL ??'',
            points: 0,
          ).toMap(),
        );
  }
  Future<void> _updateUserData(DataMap data) async{
    await _cloudStoreClient.
       collection('users')
       .doc(_authClient.currentUser?.uid)
       .set(data);
  }
  
 }