

import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/data/datasources/on_boarding_local_data_sources.dart';
import 'package:education_app/src/onboarding/data/repo/on_boarding_repo_impl.dart';
import 'package:education_app/src/onboarding/domain/repo/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockonBoardingLocalDataSrc extends Mock implements OnBoardingLocalDataSource{}
void main(){
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockonBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () {

    expect(repoImpl, isA<OnBoardingRepo>());
    
  });
  group('cacheFirstTimer', () {
    test('should complete successfully when call to the local source is successfull',
     () async{
      when(() => localDataSource.cacheFirstTimer()).thenAnswer
      ((_)async  =>Future.value());

      final result = await repoImpl.cacheFirstTimer();
      expect(result, equals( const Right<dynamic,void>(null))
      );
      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
     });

     test('should return [CacheFailure ] when call to the local sorce '
     'is unsuccessfull' ,
     () async {
        when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const   CacheException(message:'Insufficient Storage',statusCode: 500,
        ),
        );
        final result = await repoImpl.cacheFirstTimer();
        expect(result, Left<CacheFailure,dynamic>(
          CacheFailure(message: 'Insufficient Storage', statusCode: 500),

        )
        ,);
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
     }
     );
  });
  group('checkIfUserisFirstTimer', () { 
    test('should return true if user is [checkIfUserIsFirstTimer] ', () async {
    when(()=> localDataSource.checkIfUserIsFirstTimer()).thenAnswer((_) =>
     Future.value(true),);

     final result =await  repoImpl.checkIfUserFirstTimer();
     expect(result, equals(const Right<dynamic,bool>(true)));
     verify(()=> localDataSource.checkIfUserIsFirstTimer()).called(1);
     verifyNoMoreInteractions(localDataSource);
     

    });
   

    test('should resturn false if user is not first timer', ()async  {
       when(()=> localDataSource.checkIfUserIsFirstTimer()).thenAnswer((_) => 
    Future.value(false),
    );
    final result = await repoImpl.checkIfUserFirstTimer();
    expect(result, equals(const Right<dynamic,bool>(false)) );
   
       verify(()=> localDataSource.checkIfUserIsFirstTimer()).called(1);
     verifyNoMoreInteractions(localDataSource);
      
    });
    test('should return CacheFailure when call to the localdata '
    'source is unsuccessfull', () async {
      when(()=> localDataSource.checkIfUserIsFirstTimer()).thenThrow(
        const CacheException(message: 'InSufficient Permission', statusCode: 403),
      );
      final result = await repoImpl.checkIfUserFirstTimer();
       expect(result, equals(
        Left<CacheFailure,bool>( CacheFailure(
      message: 'InSufficient Permission', statusCode: 403,),)
        
      
      ),
      );
        verify(()=> localDataSource.checkIfUserIsFirstTimer()).called(1);
     verifyNoMoreInteractions(localDataSource);
      
    });
  });
}