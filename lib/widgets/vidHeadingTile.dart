import 'package:flutter/material.dart';
import 'package:video_learning/providers/vidProvider.dart';
import 'package:video_learning/screens/quizScreen.dart';
import 'package:video_learning/screens/quizStartScreen.dart';
import 'package:video_learning/screens/vidScreen.dart';



class VidHeadingTile extends StatelessWidget {
  final VidItem vidItem;
  VidHeadingTile(this.vidItem);

  List<Color> randomColors = [
    Color.fromRGBO(94, 151, 202, 1),
    Color.fromRGBO(81,116,164,1),
    Color.fromRGBO(89,84,132,1),
    Color.fromRGBO(80,69,98,1),
    Color.fromRGBO(80,69,98,1),
    Color.fromRGBO(89,84,132,1),
    Color.fromRGBO(81,116,164,1),
    Color.fromRGBO(94, 151, 202, 1),
  ];
  int randomIdx =0;
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_){
              //return VidScreen(vidItem: vidItem);
            //return QuizStartScreen(vidItem);
            return VidScreen(vidItem: vidItem,);
        }))
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8,top: 5),
        child: Column(
          children: <Widget>[
            Image.asset(vidItem.image),
            ListTile(
              tileColor: Color.fromRGBO(112, 107, 178, 1),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.play_arrow,
                  size: 12,
                  color: Colors.black,
                ),
              ),
              title: Text(
                vidItem.heading,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              subtitle: Text(
                vidItem.duration,
                  style: TextStyle(color: Colors.white70,),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )
    );
    }
  }