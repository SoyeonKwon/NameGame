
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:name_game/leaderboard/views/leaderboard_component.dart';
import 'package:name_game/final_screen/presenter/final_presenter.dart';
import 'package:name_game/final_screen/views/final_component.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_view.dart';
import '../presenter/solveQuestions_presenter.dart';
import 'package:quiver/async.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../../autoquestion.dart';
import '../../main.dart';
import '../../user.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import '../../api.dart';
import 'package:intl/intl.dart';

class SolveQuestionsPage extends StatefulWidget{
  final SolveQuestionsPresenter presenter;

  SolveQuestionsPage(this.presenter, {required Key? key, required this.title, required this.user}) : super(key: key);

  final String title;
  Account user;

  @override
  _SolveQuestionsState createState() => _SolveQuestionsState();

}

class _SolveQuestionsState extends State<SolveQuestionsPage>
    with SingleTickerProviderStateMixin implements SolveQuestionsView {
  late AudioPlayer playingAudioPlayer;
  String pathBackgroundMusic = 'assets/ingame-10sec.mp3';
  late AudioPlayer correctAudioPlayer;
  String pathCorrectSound = 'assets/correct2-answer.wav';
  late AudioPlayer wrongAudioPlayer;
  String pathWrongSound = 'assets/wrong-answer.wav';
  late AudioPlayer gongAudioPlayer;
  String pathGongSound = 'assets/gongsound.mp3';

  late Account user;

  List<Color> _colors = <Color>[Colors.amber, Colors.red, Colors.green];
  int a_color = 0;
  int b_color = 0;
  int c_color = 0;
  int d_color = 0;
  int e_color = 0;
  double score = 0;
  String nextOrFinish = "next";
  //user info
  String form1 = "OneNameMultipleYears";
  String form2 = "MultipleNamesOneYear";
  int questionCount = 0;
  int questionTotal = 10;

  late AutoQuestion autoQuestion;

  String question = "";
  String answer = "";
  String a = "";
  String b = "";
  String c = "";
  String d = "";
  String e = "";

  bool next = false;
  bool finish = false;

  Map<dynamic, dynamic> questionAndAnswer = {};

  int start = 10000;
  int current = 0;

  double percentage = 0;
  double progress = 0;

  late CountdownTimer countdownTimer;

  final ScrollController _Controller = ScrollController();

  void startTimer() {
    print("startTimer called");
    countdownTimer = new CountdownTimer(
      new Duration(milliseconds: start),
      new Duration(milliseconds: 20),
    );

    var sub = countdownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        current = start - duration.elapsed.inMilliseconds;
        progress = (start - current) / 10000;
        percentage = progress * 10;
      });
    });

    sub.onDone(() {
      print("Done");
      next = true;
      updateButtonColor(answer);
      sub.cancel();
    });
  }

  void firstPlayMusic() async {
    await playingAudioPlayer.setAsset(pathBackgroundMusic);
    await correctAudioPlayer.setAsset(pathCorrectSound);
    await wrongAudioPlayer.setAsset(pathWrongSound);
    await gongAudioPlayer.setAsset(pathGongSound);
    playingAudioPlayer.play();
  }

  void playMusic() {
    playingAudioPlayer.seek(Duration.zero);
    playingAudioPlayer.play();
  }

  void playCorrectSound() {
    correctAudioPlayer.seek(Duration.zero);
    correctAudioPlayer.play();
  }

  void playWrongSound() {
    wrongAudioPlayer.seek(Duration.zero);
    wrongAudioPlayer.play();
  }

  void playGongSound() {
    gongAudioPlayer.seek(Duration.zero);
    gongAudioPlayer.play();
  }

  @override
  void initState() {
    super.initState();
    score = 0;
    playingAudioPlayer = AudioPlayer();
    correctAudioPlayer = AudioPlayer();
    wrongAudioPlayer = AudioPlayer();
    gongAudioPlayer = AudioPlayer();
    this.user = this.widget.user;
    this.widget.presenter.solveQuestionsView = this;
    startTimer();
    if(user.form == "OneNameMultipleYears") {
      autoQuestion = new AutoQuestion("OneNameMultipleYears");
    }
    else {
      autoQuestion = new AutoQuestion("MultipleNamesOneYear");
    }
    getNextQuestion();
    questionCount = 1;
    firstPlayMusic();
  }

  void nextPressed() {
    playMusic();
    updateQuestion();
    startTimer();
    questionCount++;
  }

  void getNextQuestion() {
      questionAndAnswer = autoQuestion.getQuestions();
      question = questionAndAnswer["question"];
      a = questionAndAnswer["a"];
      b = questionAndAnswer["b"];
      c = questionAndAnswer["c"];
      d = questionAndAnswer["d"];
      e = questionAndAnswer["e"];
      answer = questionAndAnswer["answer"];
 }

  void updateQuestion() {
    questionAndAnswer = autoQuestion.getQuestions();
    print("updateQuestion: ");
    print(questionAndAnswer);
    setState(() {
      question = questionAndAnswer["question"];
      a = questionAndAnswer["a"];
      b = questionAndAnswer["b"];
      c = questionAndAnswer["c"];
      d = questionAndAnswer["d"];
      e = questionAndAnswer["e"];
      answer = questionAndAnswer["answer"];
      a_color = 0;
      b_color = 0;
      c_color = 0;
      d_color = 0;
      e_color = 0;
      next = false;
    });
  }

  void checkAnswer(String choice){
    if(choice == answer){
      score = score + (1 - progress) * 100;
      print("Score: " + score.toString());
      print("Progress: " + (1-progress).toString());
      countdownTimer.cancel();
      setState(() {
        next = true;
      });
    }
      updateButtonColor(choice);
  }

  void insertScore() async {
    final dio = Dio();	// Http client
    final client = RestClient(dio);
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss a');
    String dateNow = dateFormat.format(DateTime.now());
    String twoDecimalPointsScore = score.toStringAsFixed(2);
    score = double.parse(twoDecimalPointsScore);
    Map <String, dynamic> req1 = {"username" : user.username, "score" : score, "date" : dateNow};
    var res1 = await client.insertScore(req1);
    print(res1);
    print("highScore: " + user.highScore.toString() + ", score: " + score.toString());
    if(user.highScore < score) {
      user.highScore = score;
      Map <String, dynamic> req2 = {"username" : user.username, "highScore" : score, "date" : dateNow};
      var res2 = await client.updateHighScoreAndDate(req2);
      print("highScoreUpdated: " + res2);
    }
  }

  void updateButtonColor(String choice){
    if(choice == "a"){
      if(choice == answer) {
        playCorrectSound();
        playingAudioPlayer.pause();
        setState(() {
          a_color = 2;
        });
      }
      else setState(() {
        playWrongSound();
        a_color = 1;
      });
    }
    else if(choice == "b"){
      if(choice == answer) {
        playCorrectSound();
        playingAudioPlayer.pause();
        setState(() {
          b_color = 2;
        });
      }
      else setState(() {
        playWrongSound();
        b_color = 1;
      });
    }
    else if(choice == "c"){
      if(choice == answer) {
        playCorrectSound();
        playingAudioPlayer.pause();
        setState(() {
          c_color = 2;
        });
      }
      else setState(() {
        playWrongSound();
        c_color = 1;
      });
    }
    else if(choice == "d"){
      if(choice == answer) {
        playCorrectSound();
        playingAudioPlayer.pause();
        setState(() {
          d_color = 2;
        });
      }
      else setState(() {
        playWrongSound();
        d_color = 1;
      });
    }
    else {
      if(choice == answer) {
        playCorrectSound();
        playingAudioPlayer.pause();
        setState(() {
          e_color = 2;
        });
      }
      else setState(() {
        playWrongSound();
        e_color = 1;
      });
    }

  }


@override
Widget build(BuildContext context) {

  var timerProcessIndicator = Container(
    width: double.infinity,
    height: 20.0,
    padding: EdgeInsets.symmetric(horizontal: 24.0),
    child: LiquidLinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation(Colors.red),
      borderRadius: 12.0,
      direction: Axis.horizontal,
      center: Text(
        "${(10 - percentage).toStringAsFixed(0)} SEC LEFT!",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  var questionView = Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Text (
      '$question',
      style: const TextStyle(fontSize: 18)
    ),
  );

  var choicesView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 100,
        child: ElevatedButton(
            child: Text("(a) " + '$a', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              primary: _colors[a_color],
            ),
            onPressed: () {
              checkAnswer("a");
            }),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 100,
        child: ElevatedButton(
            child: Text("(b) " + '$b', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
                primary: _colors[b_color],
            ),
            onPressed: () {
              checkAnswer("b");
            }),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 100,
        child: ElevatedButton(
            child: Text("(c) " + '$c', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
                primary: _colors[c_color],
            ),
            onPressed: () {
              checkAnswer("c");
            }),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 100,
        child: ElevatedButton(
            child: Text("(d) " + '$d', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
                primary: _colors[d_color],
            ),
            onPressed: () {
              checkAnswer("d");
            }),
      ),
        Container(
          width: 100,
          // height: 30,
          child: ElevatedButton(
              child: Text("(e) " + '$e', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                primary: _colors[e_color],
              ),
              onPressed: () {
                checkAnswer("e");
              }),
        ),
      ]);

  var nextButton = Visibility(
    child: Container(
      //padding: EdgeInsets.only(top: 10),
      width: 100,
      child: ElevatedButton(
          child: Text("$nextOrFinish"),
          style: ElevatedButton.styleFrom(primary: _colors[0]),
          onPressed: () {
            if(questionCount == questionTotal) {
              insertScore();
              playGongSound();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return FinalRoute(score);
                  }));
            }
            else {
              nextPressed();
            }
          }),
    ),
    visible: next
  );

  var endText = Visibility (
    child: Text("FINISH! Your score is " + '$score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    visible: finish,
  );

  return Scaffold(
      appBar: AppBar(
        title: Text("START"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              countdownTimer.cancel();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomepageRoute(),
                ),
                    (route) => false,
              );
            },
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: questionView,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 50),
                alignment: Alignment.center,
                child: choicesView,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 80),
                child: timerProcessIndicator,
              ),
              Container(
                child: nextButton,
              ),
              Container(
                child: endText,
              ),
              // Expanded(
              //   child: _allViews,
              // ),
      ])));
}


}


class FinalRoute extends StatefulWidget {
  double score = 0;
  FinalRoute(double score){
    this.score = score;
  }
  @override
  _FinalRoute createState() => _FinalRoute(this.score);
}

class _FinalRoute extends State<FinalRoute>{
  double score = 0;
  _FinalRoute(double score){
    this.score = score;
  }
  @override
  Widget build(BuildContext context) {
    return new FinalPage(
      new BasicFinalPresenter(), title: 'Final Screen', score: this.score, key: Key("Final"),);
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

// class LeaderBoardRoute extends StatefulWidget {
//   @override
//   _LeaderBoardRoute createState() => _LeaderBoardRoute();
// }
//
// class _LeaderBoardRoute extends State<LeaderBoardRoute>{
//   @override
//   Widget build(BuildContext context) {
//     return new LeaderBoardPage(
//       highscore: 100,user: 'user1', key: Key("LeaderBoard"), allScores: all);
//
//   }
//}
