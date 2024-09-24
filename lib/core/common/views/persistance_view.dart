
import 'package:education_app/core/common/app/provider/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PersistanceView extends StatefulWidget {
  const PersistanceView({ this.body,super.key});
  final Widget? body;

  @override
  State<PersistanceView> createState() => _PersistanceViewState();
}

class _PersistanceViewState extends State<PersistanceView> 
with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body?? context.watch<TabNavigator>().currentPage.child;
  }
  
  @override

  bool get wantKeepAlive => true;
  
}