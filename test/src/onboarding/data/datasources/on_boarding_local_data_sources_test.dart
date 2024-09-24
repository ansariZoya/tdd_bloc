

import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/src/onboarding/data/datasources/on_boarding_local_data_sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp((){
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSrcImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache data', 
    ()async{
      when(() => prefs.setBool(any(), any())).thenAnswer(
        (_)async => true,);
        await localDataSource.cacheFirstTimer();
        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
    });

    test('should throw a [cacheExpection] when there is an error caching the data'
    ,
     ()async {
       when(()=> prefs.setBool(any(), any())).thenThrow(Exception());
        final methodCall = localDataSource.cacheFirstTimer();
        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
     
     });
   });

   group('checkIfUserIsFirstTimer', () { 
    test('should call [SharedPreferences] to check if user is first time and '
    'return the right response from storage when data exist', 
    ()async{
      when(() => prefs.getBool(any())).thenReturn(false);
      final result = await localDataSource.checkIfUserIsFirstTimer();
      expect(result, false);
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
      

    });
    test('should return true when there is no data in storage', 
   () async {
    when(() => prefs.getBool(any())).thenReturn(true);
    final result = await localDataSource.checkIfUserIsFirstTimer();
    expect(result, true);
    verify(()=> prefs.getBool(kFirstTimerKey)).called(1);
    verifyNoMoreInteractions(prefs);
   });
   test('should throw [chacheException] when there is an error '
   'retrieving the data', () async {
    when(() => prefs.getBool(any())).thenThrow(Exception());
    final result = localDataSource.checkIfUserIsFirstTimer();
    expect(result, throwsA(isA<CacheException>()));
    verify(() => prefs.getBool(kFirstTimerKey)).called(1);
    verifyNoMoreInteractions(prefs);
  
   });


   });
}