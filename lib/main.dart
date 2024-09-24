import 'package:education_app/core/common/app/provider/user_provider.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/service/injection_container.dart';
import 'package:education_app/core/service/router.dart';
import 'package:education_app/firebase_options.dart';
import 'package:education_app/src/dashboard/provider/dashboard_controller.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController())
      ],
      
        child: MaterialApp(
          title: 'Education app',
          theme: ThemeData(
            fontFamily: Fonts.poppins,
            colorScheme: ColorScheme.fromSwatch(
              accentColor: Colours.primaryColour,),

            useMaterial3: true,
             visualDensity: VisualDensity.adaptivePlatformDensity,
             appBarTheme: const  AppBarTheme(
              backgroundColor: Colors.transparent,
             ),
          ),
          onGenerateRoute: generateRoute,
         
        ),
      
    );
  }
}
