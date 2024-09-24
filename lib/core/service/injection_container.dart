import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/src/auth/data/repo/auth_repo_impl.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/onboarding/data/datasources/on_boarding_local_data_sources.dart';
import 'package:education_app/src/onboarding/data/repo/on_boarding_repo_impl.dart';
import 'package:education_app/src/onboarding/domain/repo/on_boarding_repo.dart';
import 'package:education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/onboarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:education_app/src/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container_main.dart';