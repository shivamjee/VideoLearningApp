import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_learning/widgets/vidHeadingTile.dart';
import 'package:video_learning/providers/vidProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';



class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var vp;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void launchWhatsApp({
    BuildContext ctx,
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return Uri.encodeFull("whatsapp://wa.me/$phone/?text=$message");//{Uri.parse(message)}";
      } else {
        return Uri.encodeFull("whatsapp://send?phone=$phone&text=$message");//{Uri.parse(message)}");
      }
    }

    if (await canLaunch(url())) {
      print("Hi");
      await launch(url());
    } else {
      setState(() {

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please Donwload WhatsApp'),
          duration: Duration(seconds: 2),
        ));
      });
      //throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    vp = Provider.of<VidProvider>(context,listen: false);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color.fromRGBO(60, 110, 246, 1), Color.fromRGBO(88, 198, 250, 1)])
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color :Theme.of(context).backgroundColor,
                ),
                padding: EdgeInsets.all(0.5),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/7,),
                child: Container(
                  //color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  child: vp.vidList.length==0 ?
                    Center(child: Text(
                      "No Videos Today",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
                      ),
                    )
                    :ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx,i)=> VidHeadingTile(vp.vidList[i]),
                      itemCount: vp.vidList.length,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                color :Theme.of(context).backgroundColor,
                child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[900],
                  onPressed: ()=> launchWhatsApp(ctx:context,phone: "91880098XXX", message: "Hi! This message is sent from Shivam's Flutter App.\nThis is my doubt: "),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child:Container(alignment:Alignment.center,width:220,child: Row(children:[Text("Ask Your Doubts on whatsapp",style: TextStyle(color: Colors.white70),),Icon(Icons.navigation,color: Colors.green,),],)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
