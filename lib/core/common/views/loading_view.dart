import 'package:education_app/core/Extension/context_extension.dart';
import 'package:flutter/material.dart';
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
     child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
         context.theme.colorScheme.secondary,
      )
    , ),
    );
  }
}
