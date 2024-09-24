
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/onboarding/data/datasources/on_boarding_local_data_sources.dart';
import 'package:education_app/src/onboarding/domain/repo/on_boarding_repo.dart';

class OnBoardingRepoImpl implements OnBoardingRepo{
  const OnBoardingRepoImpl( this._localDataSource);

  final OnBoardingLocalDataSource _localDataSource;

  @override
  ResultFuture<void> cacheFirstTimer()async {
    try {
   await _localDataSource.cacheFirstTimer();
   return const Right(null);
      
    }on CacheException catch (e) {
      return Left(CacheFailure(message: e.message,statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserFirstTimer() async {
   try {
     final result = await _localDataSource.checkIfUserIsFirstTimer();
     return Right(result);
   }on CacheException catch (e) {
     return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
   }
  }
}
