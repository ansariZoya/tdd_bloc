import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
   const UserInfoCard({
    required this.infoThemeColour,
    required this.infoIcon,
    required this.infoTitle,
    required this.infoValue,
    super.key});


    final Color infoThemeColour;
    final Widget infoIcon;
    final String infoTitle;
    final String infoValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: infoThemeColour,
                shape: BoxShape.circle,
                
              ),
              child: Center(child: infoIcon,),
            ),
            const SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(infoTitle,
                style: const TextStyle(fontSize: 12),),
                Text(infoValue,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),)

              ],
            )
          ],
        ),
      ),
    );
  }
}