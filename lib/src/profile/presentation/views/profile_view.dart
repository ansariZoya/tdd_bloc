import 'package:education_app/core/common/widget/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/profile/presentation/Widgets/profile_app_bar.dart';
import 'package:education_app/src/profile/presentation/refractor/profile_body.dart';
import 'package:education_app/src/profile/presentation/refractor/profile_header.dart';
import 'package:flutter/material.dart';
class ProfileView extends StatelessWidget{
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar:  const ProfileAppBar(),
      body: GradientBackground(image: MediaRes.profileGradientBackground,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const[
            ProfileHeader(),
          ProfileBody(),
        ],
      ),),
    );
  }
  
 
}