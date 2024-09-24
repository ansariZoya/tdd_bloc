import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/onboarding/domain/repo/on_boarding_repo.dart';

class CacheFirstTimer extends UsecaseWithoutParams<void>{
   CacheFirstTimer(this._repo);
  final OnBoardingRepo  _repo;

  @override 
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}
