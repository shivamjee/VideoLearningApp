import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_learning/providers/vidProvider.dart';
import 'package:video_learning/screens/homeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: VidProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          backgroundColor: Color.fromRGBO(61, 59, 96, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/" : (context)=>HomeScreen()
        },
      ),
    );
  }
}