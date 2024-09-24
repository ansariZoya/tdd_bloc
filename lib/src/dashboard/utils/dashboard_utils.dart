
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/service/injection_container.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils{
  const DashboardUtils._();
  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
  .collection('users')
  .doc(sl<FirebaseAuth>().currentUser!.uid)
  .snapshots()
  .map((event) => LocalUserModel.fromMap(event.data()!));
  
}
