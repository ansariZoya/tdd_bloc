import 'package:dartz/dartz.dart';
import 'package:education_app/src/onboarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {

  late MockOnBoardingRepo repo;
  late CheckIfUserFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserFirstTimer(repo);
  });
  
  test('should get response from[MockOnBoardingRepo]', 
  () async {
    when(() => repo.checkIfUserFirstTimer()).thenAnswer(
      (_) async  => const Right(true),);

      final result = await usecase();
      expect(result, equals(const Right<dynamic,bool>(true)));

      verify(() => repo.checkIfUserFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
  });
}