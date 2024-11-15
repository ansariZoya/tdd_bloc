

import 'package:education_app/core/enum/update_user.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

abstract class AuthRepo{
   const AuthRepo();
   ResultFuture<void>forgotPassword(
    String email,
   );
   ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
    }
    
   );
   ResultFuture<void> signUp({
    required String email,
    required String fullname,
    required String password,
   });
   
   ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
   });

}