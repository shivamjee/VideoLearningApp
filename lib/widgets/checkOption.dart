import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class CheckOption extends StatefulWidget
{
  final int idx;
  final String optionText;
  final String isCorrect;
  CheckOption(this.idx,this.optionText,this.isCorrect);

  @override
  _CheckOptionState createState() => _CheckOptionState();
}

class _CheckOptionState extends State<CheckOption> with TickerProviderStateMixin {
  List<Color> colors = [Color.fromRGBO(243, 202, 91, 1),Color.fromRGBO(128, 214, 251, 1),Color.fromRGBO(186, 234, 130, 1),Color.fromRGBO(238, 131, 121, 1)];


  bool isAnimating = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isAnimating = true;
      });
    });

  }
  @override
  void dispose() {
    super.dispose();

  }

  Widget switcher()
  {
    return AnimatedSwitcher(
      duration: Duration(seconds: 3),
      transitionBuilder: (child,animation)=>RotationTransition(
        turns: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),//Icon(Icons.done),
      ),
      child:Container(
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height/3,
        width: MediaQuery.of(context).size.width/2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        key: ValueKey<bool>(isAnimating),
        child:isAnimating?
        widget.isCorrect == "Correct Answer"?Icon(Icons.done,color: Colors.green,size: 200,):Icon(Icons.clear,color: Colors.red,size: 200,)
        :Hero(
        tag: "option${widget.idx}",
        child: Transform.scale(
          scale: 1.5,
          child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              CircleAvatar(
                radius: 20,
                backgroundColor: colors[widget.idx],
                child: Text(String.fromCharCode(65+widget.idx),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 5,),
              Text(widget.optionText,style: TextStyle(color:Colors.black,fontWeight : FontWeight.bold,fontSize :20)),
            ],
          ),
        ),
      ),
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Color.fromRGBO(115, 68, 218, 1), Color.fromRGBO(95, 83, 198, 1)])
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/4,),
              widget.idx == -1?
              Spin(
                duration: Duration(seconds: 1),
                spins: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child:Icon(Icons.clear,color: Colors.red,size: 200,),
                ),
              )
              :switcher(),
              isAnimating ? FadeIn(duration:Duration(seconds: 3),child: Text(widget.isCorrect,style: TextStyle(color:Colors.white,fontWeight : FontWeight.bold,fontSize :20))):SizedBox(height: 1,),
              SizedBox(height: 20,),
              Spacer(),
              isAnimating? FadeIn(
                duration: Duration(seconds: 3),
                child: RaisedButton(
                  color: Colors.blue[900],
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  }, child: Text("Continue?",style: TextStyle(color:Colors.white,fontWeight : FontWeight.bold,fontSize :20)),
                ),
              ):SizedBox(height: 1,),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}