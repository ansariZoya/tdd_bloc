
import 'dart:convert';

import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
   var tLocalUserModel = LocalUserModel.empty();

  
  test('should be a subclass of [UserModel]entity', () => 
  expect(tLocalUserModel,isA<LocalUser>(),),);

  final tMap = jsonDecode(fixtures('user.json')) as DataMap;


group('from Map', () {
  test('should return valid [LocalUsermodel] from map', () {
    
    final result = LocalUserModel.fromMap(tMap);
    expect(result, equals(tLocalUserModel));
  });
  test('sould throw an [Error] when the  map is invalid', () {
    final map = DataMap.from(tMap)..remove('uid');
    const call = LocalUserModel.fromMap;
   
   expect(() => call(map),throwsA(isA<Error>()));
  });
  
});
group('toMap', () {
  test('should return valid [Datamap] from model', () {
    final result = tLocalUserModel.toMap();
    expect(result, equals(tMap));
  });
  
});
group('copyWith', () {
  test('should return [LocalUserModel.empty] with updated value ', () {
    final result = tLocalUserModel.copyWith(uid: '2');
    expect(result.uid, '2');
    
  });
  
});

}
