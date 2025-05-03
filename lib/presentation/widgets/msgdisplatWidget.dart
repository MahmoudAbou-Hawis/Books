import 'package:flutter/material.dart';

class Msgdisplatwidget extends StatelessWidget {
  final String msg;

  const Msgdisplatwidget({super.key, required this.msg});
  @override
  Widget build(BuildContext context) {
      final  screenWidth = MediaQuery.of(context).size.width;
      final  screenHight = MediaQuery.of(context).size.height;

    return Center(
      child :Container(
        width: screenWidth * 0.6,
        height: screenHight* 0.3,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
      child: Column(
        children: [Icon(Icons.sentiment_dissatisfied , size: screenHight * 0.3 * 0.5 ,), Text(msg , style: TextStyle(fontSize: 15 ),) ,
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    ))
    ,
    );
  }
}
