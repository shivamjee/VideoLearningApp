import 'package:flutter/material.dart';
import 'dart:async';

import 'package:video_learning/providers/vidProvider.dart';
import 'package:video_learning/screens/quizScreen.dart';


class QuizStartScreen extends StatefulWidget {
  final VidItem vidItem;
  QuizStartScreen({this.vidItem});

  @override
  _QuizStartScreenState createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> with TickerProviderStateMixin
{
  AnimationController controller;
  AnimationController controller2;
  Animation<double> animation;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${((duration.inSeconds % 60)+1).toString()}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    //For Auto Start
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    controller.addListener(() {
      if(controller.isAnimating == false)
      {
        controller2.stop();
        controller2.dispose();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) {
              return QuizScreen(vidItem:widget.vidItem);
            }));
      }

    });
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse:true);
    animation = CurvedAnimation(
        parent: controller2,
        curve: Curves.easeIn
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.removeListener(() {
      print("Removed");
    });
    controller.dispose();
  }
  /*
  WillPopScope(
        onWillPop: ()=> Navigator.of(context).pushNamed("/"),
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    color: Colors.black,
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Quiz starts in ...",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10,),
                        FadeTransition(
                          opacity: animation,
                          child: Text(
                            controller.value == 0 ? "0":timerString,
                            style: TextStyle(
                                fontSize: 112.0,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}


/*Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: Colors.redAccent[100],
                                      )),
                                ),*/
/*class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset(50.0, 40.0) & size/1.4, math.pi*1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}*/
