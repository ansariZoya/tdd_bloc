
import 'package:education_app/core/common/app/provider/tab_navigator.dart';
import 'package:education_app/core/common/views/persistance_view.dart';
import 'package:education_app/src/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class DashboardController extends ChangeNotifier{
  List<int> _indexhistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(create: (_)=> TabNavigator(
      TabItem(child:const Placeholder()),),
      child: const PersistanceView(),),

      ChangeNotifierProvider(create: (_)=> TabNavigator(
      TabItem(child:const Placeholder()),),
      child: const PersistanceView(),),

      ChangeNotifierProvider(create: (_)=> TabNavigator(
      TabItem(child:const Placeholder()),),
      child: const PersistanceView(),),
      
      ChangeNotifierProvider(create: (_)=> TabNavigator(
      TabItem(
        child:const ProfileView()),),
        child: const PersistanceView(),
      ),


    
     

  ];
  List<Widget> get screens => _screens;
  int _currentindex = 3;

  int get currentIndex => _currentindex;

  void changeIndex(int index){
    if(_currentindex==index) return;
    _currentindex = index;
    _indexhistory.add(index);
    notifyListeners();
  }
  void goBack(){
    if(_indexhistory.length == 1) return;
    _indexhistory.removeLast();
    _currentindex  =_indexhistory.last;
    notifyListeners();

  }
  void reset(){
    _indexhistory =[0];
    _currentindex = 0;
    notifyListeners();
  }
}