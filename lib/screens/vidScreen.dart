import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_learning/providers/vidProvider.dart';
import 'package:video_learning/screens/quizStartScreen.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:animate_do/animate_do.dart';

class VidScreen extends StatefulWidget
{
  final VidItem vidItem;
  VidScreen({this.vidItem});
  @override
  _VidScreenState createState() => _VidScreenState();
}

class _VidScreenState extends State<VidScreen>
{
  ChewieController _chewieController;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool isNotesOpen = false;
  String notesText = "";
  final titleInput = TextEditingController();
  var listenerFlag;
  var vp;

  void addNotes(BuildContext context) async
  {
    setState(() async{
      _chewieController.isPlaying? _chewieController.pause():null;
      Duration dur = _controller.value.position;

      // create a dialogue to take input and on pressing okay, put it in the list and play video
      //showDialog(context: ctx
     await showModalBottomSheet(
        context: context,
        builder: (_)
          { return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Add Notes",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Text("Add cue at ${dur.inMinutes.remainder(60).toString().padLeft(2, '0')}:${dur.inSeconds.remainder(60).toString().padLeft(2, '0')}"),
                //SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Text',
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(new Radius.circular(25.0))
                    ),
                  ),
                  controller: titleInput,
                  maxLines: 10,
                ),
                Spacer(),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('OK',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: (){
                    setState(() {
                      vp.updateCue(dur,titleInput.text,widget.vidItem.id);
                      //widget.vidItem.cuePoints.putIfAbsent(dur, () => titleInput.text);
                      titleInput.clear();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          );},
      );
      _chewieController.play();
    });

  }
  void openNotes(Duration dur,String text)
  {
    setState(() {
      _chewieController.seekTo(dur+Duration(seconds: 1));
      _chewieController.isPlaying ? _chewieController.pause():null;
      isNotesOpen = !isNotesOpen;
      notesText = text;
    });
  }

  Future<bool> goToHome() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the Video!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  _chewieController.pause();
                  vp.updateTime(_controller.value.position,widget.vidItem.id);
                  //widget.vidItem.updateTime(_controller.value.position);
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  @override
  void initState() {
    super.initState();
    listenerFlag=0;
    _controller = VideoPlayerController.asset(widget.vidItem.address);

    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      print(_controller.value.duration);
      _controller.addListener(() {
        var key = _controller.value.position;
        var key2 = Duration(hours: key.inDays,minutes: key.inMinutes,seconds: key.inSeconds);
        if(listenerFlag == 0)
        {
          if(widget.vidItem.cuePoints.containsKey(key2))
          {
            listenerFlag =1;
            print("VID SHOULD STOP HERE");
            openNotes(key2, widget.vidItem.cuePoints[key2]);
          }
        }

      });
      var listenerFlag2 = 0;
      _controller.addListener(() {//custom Listner
        if(listenerFlag2 == 0)
        {
          if ( _controller.value.initialized && (_controller.value.position.inSeconds >= _controller.value.duration.inSeconds)) {
            print("VIDEO IS OVER");

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) {
                  return QuizStartScreen(vidItem:widget.vidItem);
                }));
            vp.updateTime(Duration.zero,widget.vidItem.id);
            listenerFlag2 = 1;
          }
        }

      }
    );
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        aspectRatio:16/9,
        autoInitialize: true,
        looping: false,
        allowedScreenSleep: false,
        //startAt: widget.vidItem.vidSartFrom,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
      _controller.play();
      _controller.seekTo(widget.vidItem.vidSartFrom);

    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      print("Listener Removed");
    });
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    vp = Provider.of<VidProvider>(context);
    var keys = widget.vidItem.cuePoints.keys.toList();
    keys.sort();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.vidItem.heading),
      ),
      body: WillPopScope(
        onWillPop: goToHome,
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FadeOut(
                      child: AspectRatio(
                        aspectRatio: 16/9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
                      ),
                    ),
                    keys.length == 0
                    ?Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text("Click the + icon to start adding notes",style: TextStyle(color: Colors.white),),
                    )
                    :isNotesOpen
                      ?GestureDetector(
                      onTap: (){
                        setState(() {
                          isNotesOpen = !isNotesOpen;
                          _chewieController.seekTo(_controller.value.position+Duration(seconds: 1));
                          _chewieController.isPlaying?null:_chewieController.play();
                          listenerFlag = 0;
                        });
                      },
                      child:FadeOut(
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.yellow[700],),
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width-20,

                          child:  Column(
                              children: [
                                Text("My Notes",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                SizedBox(height: 20,),
                                Text(notesText)
                              ],
                            ),
                          ),
                      ),
                      )
                    //To view all cue points
                      :Column(
                      children: [
                        Text("My Notes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white,decoration: TextDecoration.underline),),
                        SizedBox(height: 10,),
                        Text("Click any to expand",style: TextStyle(fontSize: 16,color: Colors.white),),
                        ListView.builder(
                          padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemBuilder: (ctx,i)=>
                            ListTile(
                              onTap: ()=>openNotes(keys[i],widget.vidItem.cuePoints[keys[i]]),
                              //tileColor: Color.fromRGBO(112, 107, 178, 1),
                              tileColor: Colors.yellow[800],
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text((i+1).toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              ),
                              title: Text(widget.vidItem.cuePoints[keys[i]],style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,),
                              subtitle: Text("${keys[i].inMinutes.remainder(60).toString().padLeft(2, '0')}:${keys[i].inSeconds.remainder(60).toString().padLeft(2, '0')}",style: TextStyle(color: Colors.blue[900],decoration: TextDecoration.underline),),
                            ),
                        itemCount: keys.length,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>addNotes(context),
        child: Icon(
          Icons.add
        ),
      ),
    );
  }
}