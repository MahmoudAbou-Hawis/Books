import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
              color: Colors.black,
              size:  screenWidth/10,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Your books',
              style: TextStyle(color: Colors.black, fontSize: screenWidth  / 18,),
              
            
            ),
          ],
        ),
    );
  }
}
