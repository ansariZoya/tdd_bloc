import 'package:education_app/core/Extension/context_extension.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/src/onboarding/domain/entities/page_content.dart';
import 'package:education_app/src/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});
  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image,height:context.height*.4),
        SizedBox(height: context.height*.03,),
        Padding(padding:const  EdgeInsets.all(20).copyWith(bottom: 0),
        child: Column(
          children: [
            Text(pageContent.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: Fonts.aeonik,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: context.height*.02,),
            Text(
              pageContent.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: context.height*.05,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 17,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colours.primaryColour,
              ),
              onPressed:(){
            
              context.read<OnBoardingCubit>().cacheFirstTimer();
            }
             , child: const Text('Get Started',
             style: TextStyle(
              fontFamily: Fonts.aeonik,
              fontSize: 20,
              fontWeight: FontWeight.bold
             ,),),),
          ],
        ),)
      ],
    );
  }
}