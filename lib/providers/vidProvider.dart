import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizQuestion
{
  @required final String ques;
  @required final List<String> options;
  @required final String ans;
  QuizQuestion({
    this.ques,
    this.options,
    this.ans,
  });
}
class VidItem
{
  @required final String id;
  @required final String heading;
  @required final String duration;
  @required final String address;
  @required  Duration vidSartFrom;
  @required final String image;
  @required final List<QuizQuestion> quiz;
  @required final Map<Duration,String> cuePoints;
  @required  bool isQuizDone;
  @required  int quizIdx;
  @required  int quizPoints;
  @required  int totalTime;
  final List<String> isCorrectList;
  final List<String> indTime;


  VidItem({
    this.id,
    this.heading,
    this.duration,
    this.address,
    this.vidSartFrom,
    this.image,
    this.cuePoints,
    this.quiz,
    this.isQuizDone = false,
    this.quizIdx=0,
    this.quizPoints=0,
    this.totalTime =0,
    this.isCorrectList,
    this.indTime,
  });


}

//Dont need provider for now as there is no change in data .. but Can be converted into one very easily

class VidProvider with ChangeNotifier
{
  List<VidItem> vidList = [
    VidItem(
      id: "0",
      heading: "Pythagoras theorem",
      duration: "1:56",
      address: "assets/pythagorasTheoremVid.mp4",
      vidSartFrom: Duration.zero,
      image: "assets/pythagorasImg.png",
      quiz: [
        QuizQuestion(ques: "Ques1", options:["option1", "option2", "option3", "option4"], ans: "option1"),
        QuizQuestion(ques: "Ques2", options:["option5", "option6", "option7", "option8"], ans: "option6"),
        QuizQuestion(ques: "Ques3", options:["option1", "option2", "option3", "option4"], ans: "option3"),
        QuizQuestion(ques: "Ques4", options:["option1", "option2", "option3", "option4"], ans: "option4"),
      ],
      cuePoints: {Duration(seconds: 10):"Sample Hardcoded Cue"},
      isCorrectList: [],
      indTime: [],
    ),
    VidItem(
      id: "1",
      heading: "Square Root",
      duration: "4:11",
      address: "assets/squareRootVid.mp4",
      vidSartFrom: Duration.zero,
      image: "assets/squareRootImg.png",
      quiz: [
        QuizQuestion(ques: "Ques1", options:["option1", "option2", "option3", "option4"], ans: "option1"),
        QuizQuestion(ques: "Ques2", options:["option1", "option2", "option3", "option4"], ans: "option2"),
        QuizQuestion(ques: "Ques3", options:["option1", "option2", "option3", "option4"], ans: "option3"),
        QuizQuestion(ques: "Ques4", options:["option1", "option2", "option3", "option4"], ans: "option4"),
      ],
      cuePoints: {},
      isCorrectList: [],
      indTime: [],
    ),
    VidItem(
      id: "2",
      heading: "Addition",
      duration: "3:32",
      address: "assets/addVid.mp4",
      vidSartFrom: Duration.zero,
      image: "assets/addImg.png",
      quiz: [
        QuizQuestion(ques: "Ques1", options:["option1", "option2", "option3", "option4"], ans: "option1"),
        QuizQuestion(ques: "Ques2", options:["option1", "option2", "option3", "option4"], ans: "option2"),
        QuizQuestion(ques: "Ques3", options:["option1", "option2", "option3", "option4"], ans: "option3"),
        QuizQuestion(ques: "Ques4", options:["option1", "option2", "option3", "option4"], ans: "option4"),
      ],
      cuePoints: {},
      isCorrectList: [],
      indTime: [],
    ),
    VidItem(
      id: "3",
      heading: "Subtraction",
      duration: "3:32",
      address: "assets/addVid.mp4",
      vidSartFrom: Duration.zero,
      image: "assets/subImg.png",
      quiz: [
        QuizQuestion(ques: "Ques1", options:["option1", "option2", "option3", "option4"], ans: "option1"),
        QuizQuestion(ques: "Ques2", options:["option1", "option2", "option3", "option4"], ans: "option2"),
        QuizQuestion(ques: "Ques3", options:["option1", "option2", "option3", "option4"], ans: "option3"),
        QuizQuestion(ques: "Ques4", options:["option1", "option2", "option3", "option4"], ans: "option4"),
      ],
      cuePoints: {},
      isCorrectList: [],
      indTime: [],
    ),
  ];
  void updateTime(Duration dur,var idx)
  {
    int id= int.parse(idx);
    vidList[id].vidSartFrom = dur;
    notifyListeners();
  }
  void updateCue(var key,var text,var idx)
  {
    int id= int.parse(idx);
    vidList[id].cuePoints.putIfAbsent(key, () => text);
    notifyListeners();
  }
  void quizStatus(var status,var idx)
  {
    int id= int.parse(idx);
    vidList[id].isQuizDone = status;
    notifyListeners();
  }
  void updateQuizCorrectList( List<String> isCorrectlist, String indTime,int totalTime,int point,var idx)
  {
    int id= int.parse(idx);
    vidList[id].isCorrectList.addAll(isCorrectlist);
    vidList[id].indTime.add(indTime);
    vidList[id].totalTime+=totalTime;
    vidList[id].quizPoints+=point;
    notifyListeners();
  }
  void updateQuizIdx(var idxx)
  {
    int id= int.parse(idxx);
    vidList[id].quizIdx++;
    notifyListeners();
  }


}