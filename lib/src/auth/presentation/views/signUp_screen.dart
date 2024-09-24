

import 'package:education_app/core/common/app/provider/user_provider.dart';
import 'package:education_app/core/common/widget/gradient_background.dart';
import 'package:education_app/core/common/widget/rounded_button.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/views/signin_screen.dart';
import 'package:education_app/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
         if( state is AuthError){
          CoreUtils.showSnackBar(context, state.message);
         }
         else if( state is SignedUp){
          context.read<AuthBloc>().add(
            SignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),),
          );
         }else if(state is SignedIn){
          context.read<UserProvider>().initUser(state.user as LocalUserModel);
         }
        },
        builder: (context, state) {
          return GradientBackground(
          image: MediaRes.authGradientBackground,
          child:  SafeArea(child: 
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children:  [
                const Text('Easy to learn discover more skills',
                style: TextStyle(
                  fontFamily: Fonts.aeonik,
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),),
                const SizedBox(height: 10,),
                const Text('sign up for an account',
                style: TextStyle(fontSize: 10),),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                  child: const Text('already have an account?'),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context,
                     SignInScreen.routeName,);
                  },),
                ),
              const  SizedBox(height: 10,),
              SignUpForm(
                emailController: emailController, 
                passwordController: passwordController, 
                confirmPasswordController: confirmPasswordController, 
                fullNameController: fullNameController, 
                formKey: formKey,),
               const SizedBox(height: 30,),
                if(state is AuthLoading)
               const Center(child: CircularProgressIndicator(),)
               else RoundedButton(
                label: 'sign up', 
                onPressed: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  FirebaseAuth.instance.currentUser?.reload();
                  if(formKey.currentState!.validate()){
                    context.read<AuthBloc>().add(
                      SignUpEvent(
                        email: emailController.text.trim(), 
                        password: passwordController.text.trim(), 
                        name: fullNameController.text.trim(),
                        ),
                    );
                  }

                },
                ),

                
              ],
            ),
          ),
          ),);
        },
      ),
    );
  }
}
