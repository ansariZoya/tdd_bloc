import 'package:equatable/equatable.dart';
class LocalUser extends Equatable{
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullname,
     this.groupId =const[],
     this.enrolledCourseId = const [],
     this.followers = const [],
     this.following = const[],
     this.profilePic,
     this.bio,

  
  });

  const LocalUser.empty()
  : this(uid: '',
         email: '',
         profilePic: '',
         bio: '',
         points: 0,
         fullname: '',
         groupId: const[] ,
         enrolledCourseId:const [],
         following:const [],
         followers: const[],);
  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullname;
  final List<String> groupId;
  final List<String> enrolledCourseId;
  final List<String> following;
  final List<String> followers;
  
  @override
  
  List<Object?> get props => [uid,email,
   profilePic,
        bio,
        points,
        fullname,
        groupId.length,
        enrolledCourseId.length,
        following.length,
        followers.length,];
  
  @override
  String toString(){
    return 'LocalUser{ uid: $uid , email: $email,bio: '
    '$bio ,fullname: $fullname , points:$points}';
  }
  
  





}