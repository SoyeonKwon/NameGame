import 'package:flutter/material.dart';
import 'package:name_game/solveQuestions/presenter/solveQuestions_presenter.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_component.dart';


import 'package:just_audio/just_audio.dart';

import 'package:dio/dio.dart';
import '../../api.dart';


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:name_game/final_screen/presenter/final_presenter.dart';
import 'package:name_game/final_screen/views/final_component.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_view.dart';

import 'package:quiver/async.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../../autoquestion.dart';
import '../../main.dart';
import '../../user.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import '../../api.dart';
import 'package:intl/intl.dart';


class LeaderBoardPage extends StatefulWidget{


  LeaderBoardPage({required Key? key, required this.highscore, required this.user}) : super(key: key);

  final String user;
  final double highscore;
  @override
  _LeaderBoardState createState() => _LeaderBoardState();

}

class _LeaderBoardState extends State<LeaderBoardPage> {
  // child: Center(child: Text(users[index].toString() + ' : ' + scores[index].toString())),
  int i = 0;
  int j = 0;
  // List<String> users =  List.filled(0, "", growable: true);
  // List<double> scores = List.filled(0, 0, growable: true);

  List<Map> all = new List.filled(0, {}, growable: true);
  final ScrollController _Controller = ScrollController();

  void getHighScores() async {
    String first;
    String second;
    final dio = Dio(); // Http client
    final client = RestClient(dio);


    // res is a list of Map<String, dynamic>, and res[i].data is a map with a username and its highScore
    // res => [{'username': 'user1', 'highScore':287}, {'username' : 'user2', 'highScore':465}]
    // res[i].data = {'username': 'useri', 'highScore':123}
    var res = await client.getAllHighscores();
    print(res[0].data['username'] + ": " + res[0].data['highScore'].toString());
    print(res[1].data['username'] + ": " + res[1].data['highScore'].toString());
    for(int r = 0; r < res.length; r++){
      all.add({'username' : res[r].data['username'], 'score' : res[r].data['highScore']});
      i++;
    }
    all.sort((a, b) => (b['score']).compareTo(a['score']));

    print(all);
    print(all[0]['username'].toString());
  }

  @override
  void initState() {
    getHighScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var _allScoresView = ListView.builder(
      padding: EdgeInsets.only(bottom: 5),
        itemCount: i,
        controller: _Controller,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(top: 10),
            // height: 10,
            child: Center(child:Text('${index + 1}' + ": USERNAME : " + '${all[index]['username'].toString()}'
                + ", SCORE: " + '${all[index]['score'].toString()}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RaleWay', color: Colors.orange))),
          );
        },
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    children: <TextSpan>[
                      TextSpan(text: 'HighScores!: ', style:     TextStyle(
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
                _allScoresView,
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


