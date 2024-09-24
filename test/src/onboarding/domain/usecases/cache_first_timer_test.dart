import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/domain/repo/on_boarding_repo.dart';
import 'package:education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {
   late OnBoardingRepo repo;
   late CacheFirstTimer usecase;

   setUp((){
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
   });

  test('should call the [OnBoardingRepo.CacheFirstTimeUser] ' 
  'and return right data ', () async {
    when(() => repo.cacheFirstTimer()).thenAnswer(
      (_) async => Left(ServerFailure(
        message: 'Unknown error occured', statusCode: 500,
        ),
        ),
        );

    final result = await usecase();
    expect(result, equals(Left<Failure,dynamic>(
      ServerFailure(
        message:'Unknown error occured', statusCode: 500,
        ),
    ),
    ),
    );
    verify(() => repo.cacheFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);



  });
  
}
