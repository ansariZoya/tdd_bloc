import 'package:bloc/bloc.dart';
import 'package:education_app/src/onboarding/domain/usecases/cache_first_timer.dart';

import 'package:education_app/src/onboarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserFirstTimer checkIfUserFirstTimer
  }) : _cacheFirstTimer = cacheFirstTimer,
  _checkIfUserFirstTimer = checkIfUserFirstTimer,
super( const OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserFirstTimer _checkIfUserFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimeUser());
    final result = await _cacheFirstTimer();

    result.fold(
      (failure) => emit(OnBoardingError(failure.errorMessage)), 
      (_) => emit( const UserCached()),);

  }
  Future<void> checkIfUserFirstTimer() async{
    emit(const CheckingIfUserIsFirstTimer());
    final result = await _checkIfUserFirstTimer();

    result.fold(
      (failure) => emit( const OnBoardingStatus(isFirstTimer: true)), 
      (status) => emit(OnBoardingStatus(isFirstTimer: status)));
  }
}
