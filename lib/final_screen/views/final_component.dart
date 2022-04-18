import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../views/final_view.dart';
import '../presenter/final_presenter.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:name_game/final_screen/presenter/final_presenter.dart';
import 'package:name_game/final_screen/views/final_component.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_view.dart';


import '../../main.dart';

import 'package:water_bottle/water_bottle.dart';


class FinalPage extends StatefulWidget {
  final FinalPresenter presenter;

  FinalPage(this.presenter, {required Key? key, required this.title, required this.score}) : super(key: key);
  final String title;
  final double score;

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> implements FinalView {


  String _text = "";
  String _message = "";
  double _score = 0;
  String _text2 = "Great Job!";
  double _scorePercent = 0;
  bool selected = true;


  final plainBottleRef = GlobalKey<WaterBottleState>();

  final chemistryBottleRef = GlobalKey<SphericalBottleState>();
  final triangleBottleRef = GlobalKey<TriangularBottleState>();
  var waterLevel = 0.75;
  var selectedStyle = 0;

  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    _score = this.widget.score;
    _text = _score.toString();
    _text = _score.toString() + "\n/1000";
    _scorePercent = _score/1000;
    print(_scorePercent);
    setState(() {
      plainBottleRef.currentState?.waterLevel = _scorePercent;// 0.0~1.
  });
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter.play();
    super.initState();
    this.widget.presenter.setFinalView = this;

  }

  @override
  void updateText(String text){
    print("calling updateText");
    setState(() {
      _text = text;
    });
  }

  String getMessage() {
    String returnText = "";

    // if _score
    return returnText;
  }


  @override
  Widget build(BuildContext context) {
    plainBottleRef.currentState?.waterLevel = _scorePercent;// 0.0~1.
    //_text = widget._text;

    // var bottle = Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     color: Colors.white,
    //     child: bottleColumn
    // );
    // var bottleColumn = Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     Spacer(),
    //     Center(
    //       child: SizedBox(
    //           width: 200,
    //           height: 300,
    //           child: WaterBottle(
    //               key: plainBottleRef,
    //               waterColor: Colors.blue,
    //               bottleColor: Colors.lightBlue,
    //               capColor: Colors.blueGrey)
    //       ),
    //     ),
    //
    //
    //
    //
    //     Spacer(),
    //
    //
    //     Spacer(),
    //   ],
    // )

    var confettiShooter = Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controllerTopCenter,
        blastDirection: 3.14 / 2,
        maxBlastForce: 5, // set a lower max blast force
        minBlastForce: 2, // set a lower min blast force
        emissionFrequency: 0.05,
        numberOfParticles: 50, // a lot of particles at once
        gravity: 1,
      ),
    );

    return SafeArea(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              confettiShooter,
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 36),
                  children: <TextSpan>[
                    TextSpan(text: 'You got a score of: ', style:     TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.blue,
                          blurRadius: 10.0,
                          offset: Offset(5.0, 5.0),
                        ),
                        Shadow(
                          color: Colors.red,
                          blurRadius: 10.0,
                          offset: Offset(-5.0, 5.0),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Text(_score.toString(),style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                fontSize: 60),
              ),
            ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(_text2 ,style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                    fontSize: 60),
                ),
              ),

              Center(
              child: SizedBox(
              width: 200,
              height: 300,
              child: WaterBottle(
              key: plainBottleRef,
              waterColor: Colors.blue,
              bottleColor: Colors.lightBlue,
              capColor: Colors.blueGrey),

              ),
              ),

              ElevatedButton(
                child: Text('Home'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomepageRoute(),
                    ),
                        (route) => false,
                  );
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  //   return HomepageRoute();
                  // }));
                },
              ),


          ])
      ),
    );
  }
}


class HomepageRoute extends StatefulWidget {
  @override
  _HomepageRoute createState() => _HomepageRoute();
}

class _HomepageRoute extends State<HomepageRoute>{
  @override
  Widget build(BuildContext context) {
    return new MyHomePage(
      title: 'Extreme Name Game', key: Key("HomePage"),);
  }
}


// class HolePainter extends CustomPainter {
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//     paint.color = Colors.blueGrey;
//     canvas.drawPath(
//       Path.combine(
//         PathOperation.difference,
//         Path()..addRRect(RRect.fromLTRBR(100, 100, 300, 300, Radius.circular(10))),
//         Path()..addRRect(RRect.fromLTRBR(110, 110, 290, 290, Radius.circular(10))),
//       ),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
//
// }
