import 'dart:async';

import 'package:education_app/core/common/widget/popup_item.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 40,
        ),
      ),
      actions: [
        PopupMenuButton(
            offset: const Offset(0, 50),
            surfaceTintColor: Colors.white,
            icon: const Icon(Icons.more_horiz),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            itemBuilder: (_) => [
                  PopupMenuItem<void>(
                    child: const PopupItem(
                        title: 'Edit Profile',
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colours.neutralTextColour,
                        )),
                    onTap: (){}
                    ),
                

                
                  const PopupMenuItem<void>(
                    child: PopupItem(
                        title: 'Notification',
                        icon: Icon(
                          Icons.notification_add,
                          color: Colours.neutralTextColour,
                        )),
              
                  ),

                  const PopupMenuItem<void>(
                    child: PopupItem(
                        title: 'help',
                        icon: Icon(
                          Icons.help_outlined,
                          color: Colours.neutralTextColour,
                        )),
                    
                  ),PopupMenuItem<void>(
                    height: 1,
                    padding: EdgeInsets.zero,
                    child: Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    endIndent: 16,
                    indent: 16,
                  )),
                  PopupMenuItem<void>(child: const PopupItem(
                    title: 'LogOut', 
                    icon: Icon(Icons.logout_outlined,
                    color: Colors.black,)),
                    onTap: ()async{
                      final navigator = Navigator.of(context);
                         await FirebaseAuth.instance.signOut();
                         unawaited(
                          navigator.pushNamedAndRemoveUntil(
                            '/',
                             (route) => false,),
                         );
                    },),

                ])
      ],
    );
  }
  
  @override
 
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}
