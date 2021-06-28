import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_learning/providers/vidProvider.dart';
import 'dart:math' as math;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:video_learning/widgets/checkOption.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget
{
  final VidItem vidItem;
  QuizScreen({this.vidItem});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {

  var vp;

  CountDownController countDownController = CountDownController();
  AnimationController controller1,controller2,controller3,controller4,controller5;
  List<Color> colors = [
    Color.fromRGBO(243, 202, 91, 1),
    Color.fromRGBO(128, 214, 251, 1),
    Color.fromRGBO(186, 234, 130, 1),
    Color.fromRGBO(238, 131, 121, 1)
  ];

  void checkMyOption(var quizList,String isCorrect,int index) async
  {
    //countDownController.pause();
    //indTime.add((10-int.parse(countDownController.getTime())).toString());
    //totalTime += (10-int.parse(countDownController.getTime()));
    bool value = await Navigator.push(
        context, MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return CheckOption(index, index == -1?"TIME OUT":quizList[widget.vidItem.quizIdx].options[index],isCorrect);
        }
      )
    );
    if  (value == true) {
      setState(() {
        vp.updateQuizIdx(widget.vidItem.id);
        controller1.reset();controller2.reset();controller3.reset();controller4.reset();
        controller1.forward();controller2.forward();controller3.forward();controller4.forward();
        countDownController.restart();
        if (widget.vidItem.quizIdx == (quizList.length))
        {
          vp.quizStatus(true,widget.vidItem.id);
          countDownController.pause();
        }

      });
    }
  }

  Widget SummaryWid(){
    //controller5.forward();
    return SingleChildScrollView(
      child: FadeIn(
        //delay: Duration(milliseconds: 1),
        controller: (controller) => controller5 = controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("QUIZ SUMMARY",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 10,),
                Text("Questions",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                Spacer(),
                Text("Time(s) ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(width: 10,),
                Text("Remarks",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(width: 10,),
                Text("Points",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),
            Divider(thickness: 2,color: Colors.black,),
            SizedBox(height: 20,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemBuilder: (ctx,i)=> Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Text((i+1).toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 10,),
                    Text("Question ${i+1} :",style: TextStyle(fontSize: 20,)),
                    Spacer(),
                    Text(widget.vidItem.indTime[i],style: TextStyle(fontSize: 20,)),
                    Text("Time",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.transparent)),
                    widget.vidItem.isCorrectList[i] == "true"? Icon(Icons.done,color: Colors.green,):Icon(Icons.clear,color: Colors.red,),
                    Text("Remar",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.transparent)),
                    Text(widget.vidItem.isCorrectList[i]=="TIMEOUT"?"0": widget.vidItem.isCorrectList[i]=="true"?"+4":"-1",style: TextStyle(fontSize: 20,)),
                  ],
                ),
              ),
              itemCount: widget.vidItem.indTime.length,
            ),
            Divider(thickness: 2,color: Colors.black,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Total Score: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("${widget.vidItem.quizPoints.toString()} Points",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Total Time: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("${widget.vidItem.totalTime.toString()} Seconds",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.all(10),
                color: Colors.blue[900],
                onPressed: ()=>Navigator.of(context).pushReplacementNamed("/"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child:Text("Go back to Home",style: TextStyle(color: Colors.white70),),
              ),
            )

          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vp = Provider.of<VidProvider>(context);
    var quizList = widget.vidItem.quiz;
    return Container(
      decoration: BoxDecoration(gradient: RadialGradient(colors: [Color.fromRGBO(115, 68, 218, 1), Color.fromRGBO(95, 83, 198, 1)])),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: (widget.vidItem.quizIdx == (quizList.length) || widget.vidItem.isQuizDone )?
          SummaryWid()
          :SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.vidItem.heading, style: TextStyle(fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                FadeInUp(
                    //manualTrigger: true,
                    controller: ( controller ) => controller1 = controller,
                    animate: true,
                    child: Text(quizList[widget.vidItem.quizIdx].ques, style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),)),
                SizedBox(height: 20,),
                Spin(
                  //manualTrigger: true,
                  controller: ( controller ) => controller2 = controller,
                  animate: true,
                  child: CircularCountDownTimer(
                    duration: 10,
                    initialDuration: 0,
                    controller: countDownController,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 4,
                    ringColor: Colors.grey[300],
                    ringGradient: null,
                    fillColor: Color.fromRGBO(205, 74, 108, 1),
                    fillGradient: null,
                    backgroundColor: Colors.transparent,
                    backgroundGradient: null,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(fontSize: 33.0, color: Colors.white,fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.SS,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: null,
                    onComplete: (){
                      String isCorrect = "TIME OUT";
                      //points-=1;
                      //isCorrectList.addAll(["TIMEOUT"]);
                      vp.updateQuizCorrectList(["TIMEOUT"],"10",10,0,widget.vidItem.id);
                      checkMyOption(quizList, isCorrect, -1);
                    },
                  ),
                ),
                //for options
                //check align for errors
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          countDownController.pause();
                          String isCorrect;
                          if (quizList[widget.vidItem.quizIdx].ans ==
                              quizList[widget.vidItem.quizIdx].options[index]) {
                            isCorrect = "Correct Answer";
                            vp.updateQuizCorrectList(["true"],((10-int.parse(countDownController.getTime())).toString()),(10-int.parse(countDownController.getTime())),4,widget.vidItem.id);
                          }
                          else {
                            isCorrect = "Wrong Answer";
                            vp.updateQuizCorrectList(["false"],((10-int.parse(countDownController.getTime())).toString()),(10-int.parse(countDownController.getTime())),(-1),widget.vidItem.id);
                          }
                          checkMyOption(quizList, isCorrect, index);
                        },
                        child: FadeInLeft(
                          key: ValueKey<int>(widget.vidItem.quizIdx),
                          //manualTrigger: true,
                          controller: (controller) => controller3 = controller,
                          animate: true,
                          child: Spin(
                            //manualTrigger: true,
                              controller: (controller) =>
                              controller4 = controller,
                              animate: true,
                              delay: Duration(milliseconds: 200),
                              child: Hero(
                                tag: "option$index",
                                child: Card(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //check ans change index and reset controller
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: colors[index],
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold),),
                                      ),
                                      Text(quizList[widget.vidItem.quizIdx].options[index],
                                          style: TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19)),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
  }
AnimatedBuilder(
animation: controller,
builder: (context, child) {
return Stack(
//alignment: Alignment.center,
children: [
Positioned.fill(
child: CustomPaint(
painter: CustomTimerPainter(
animation: controller,
backgroundColor: Colors.white,
color: Color.fromRGBO(205, 74, 108, 1),
)),
),
Align(
alignment: Alignment.topCenter,
child: Text(
controller.value == 0 ? "00" : timerString,
style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),),
),
],
);
}
),

class CustomTimerPainter extends CustomPainter {
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
    canvas.drawArc(Offset(size.width/2.7,0) & size/4, math.pi*1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
  }
*/
