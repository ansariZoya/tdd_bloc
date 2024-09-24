import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
   const LocalUserModel(
      {required super.uid,
      required super.email,
      required super.points,
      required super.fullname,
      super.groupId,
      super.enrolledCourseId,
     super.followers,
     super.following,
     super.profilePic,
     super.bio,
    });
     

    const LocalUserModel.empty() :
     this(
      uid: '',
      email: '',
      points: 0,
      fullname: '',
      profilePic: ''
      );

  LocalUserModel.fromMap(DataMap map) :super
  (
    uid: map['uid']  as String? ??'',
    email: map['email'] as String? ??'',
    points: (map['points'] as num).toInt(),
    fullname: map['fullname'] as String? ?? '',
    profilePic: map['profilepic'] as String? ??'',
    bio: map['bio']as String? ??'',
    groupId:(map['groupId'] as List<dynamic>? ??[]) .cast<String>(),
    enrolledCourseId: (map['enrolledCourseId'] as List<dynamic>? ??[]).
    cast<String>(),
    followers: (map['followers']as List<dynamic>? ??[]).cast<String>(),
    following: (map['following']as List<dynamic>? ??[]).cast<String>(),
     );


    LocalUserModel copyWith({
      String?uid,
      String?email,
      int?points,
      String? fullname,
      String?profilePic,
      String?bio,
      List<String>?groupId,
      List<String>?enrolledCourseId,
      List<String>?followers,
      List<String>?following,
    }){
      return LocalUserModel(
        uid: uid?? '',
        email: email??'',
        fullname: fullname?? '',
        profilePic: profilePic?? '',
        points: points?? 0,
        bio: bio??'',
        groupId: groupId?? [],
        enrolledCourseId: enrolledCourseId??[],
        followers: followers?? [],
        following: following?? [],

      );
    }

    DataMap toMap(){
    return {'uid':uid,
      'email':email,
      'points' : points,
      'fullname' : fullname,
      'profilePic': profilePic,
      'bio':bio,
      'groupId' :groupId,
      'enrolledCourseId' : enrolledCourseId,
      'followers': followers,
      'following' : following,
      
      
      }; 

  

      } 
     

    }
    

    
