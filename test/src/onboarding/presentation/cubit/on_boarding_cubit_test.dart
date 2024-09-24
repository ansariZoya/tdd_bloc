import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/onboarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:education_app/src/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockCacheFirstTimer extends Mock implements CacheFirstTimer{}
class MockCheckIfUserIsFirstTimer extends Mock implements
 CheckIfUserFirstTimer{}
void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer, 
      checkIfUserFirstTimer: checkIfUserIsFirstTimer,); });
 final tFailure = CacheFailure(
  message: 'InSufficient Storage permission', statusCode:4032);
     test('initial state should be [OnBoardingInitial]', () {
    expect(cubit.state, const OnBoardingInitial());
  });
  group('cacheFirstTimer', () { 
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer,UserCached] when suuccessfull',
      build: (){
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => const  Right(null),);
    return cubit;
      } ,
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const [
        CachingFirstTimeUser(),
        UserCached()

      ],
      verify: (_){
        verify(()=> cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      }
    );
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit '
      '[CachingFirstTimer,OnBoardingError]',
      build: () {
        when(()=> cacheFirstTimer()).thenAnswer(
          (_)async => Left(tFailure),);
          return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimeUser(),
        OnBoardingError(tFailure.errorMessage),
      ],
      verify: (_)  {
        verify(()=> cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  
  });
  group('checkIfUserFirstTimer', () { 
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [checkingFirstTimeUser,OnBoardingStatus] '
      'when successfull',
      build: () {
        when(()=> checkIfUserIsFirstTimer()).thenAnswer(
          (_)async  => const Right(false));
          return cubit;
      },
      act: (bloc) => cubit.checkIfUserFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isFirstTimer: false)
      ],
      verify: (_){
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckIfFirstTimeUser,OnBoardingStatus(true)] '
      'when unsuccessfull',
      build: (){
        when(() => checkIfUserIsFirstTimer()).thenAnswer(
          (_)async => Left(tFailure)
        );
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserFirstTimer(),
      expect: () => const[
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isFirstTimer: true)
      ],
      verify: (_){
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
