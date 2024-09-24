import 'package:education_app/core/Extension/context_extension.dart';
import 'package:education_app/core/common/views/page_underConstruction.dart';
import 'package:education_app/core/service/injection_container.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/views/signUp_screen.dart';
import 'package:education_app/src/auth/presentation/views/signin_screen.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:education_app/src/onboarding/data/datasources/on_boarding_local_data_sources.dart';
import 'package:education_app/src/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:education_app/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part'router_main.dart';
