import 'package:flutter/material.dart';
import 'package:name_game/solveQuestions/presenter/solveQuestions_presenter.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_component.dart';
import 'final_screen/presenter/final_presenter.dart';
import 'final_screen/views/final_component.dart';
import 'package:name_game/leaderboard/views/leaderboard_component.dart';
import 'package:just_audio/just_audio.dart';
import 'user.dart';
import 'package:dio/dio.dart';
import '../../api.dart';
import 'createNewAccount.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Game',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Extreme Name Game'),
    );
  }
}

Account userAccount = new Account();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
double score = 0;
class _MyHomePageState extends State<MyHomePage> {
  List<Map> all = new List.filled(0, {}, growable: true);
  var colors = [Colors.orange, Colors.green];
  int form1Color = 0;
  int form2Color = 0;
  late TextEditingController _answerCountController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool loginFail = false;
  bool loginSuccess = false;

  late AudioPlayer lobbyAudioPlayer;
  String path = 'assets/lobby-sound.mp3';

  String _username = "";
  String _password = "";

  @override
  void initState(){
    super.initState();
    lobbyAudioPlayer = AudioPlayer();
    playMusic();
  }

  void playMusic() async {
    await lobbyAudioPlayer.setAsset(path);
    lobbyAudioPlayer.play();
    lobbyAudioPlayer.setLoopMode(LoopMode.all);
  }

  void pauseMusic() async {
    await lobbyAudioPlayer.pause();
  }

  void checkUser() async {
    final dio = Dio();	// Http client
    final client = RestClient(dio);
    Map <String, String> req = {"username" : _username, "password" : _password};
    var res = await client.findOneUser(req);
    print(res.length);
    if(res.length == 0){
      print("Failed");
      setState(() {
        loginFail = true;
      });
    }
    else {
      setState(() {
        loginFail = false;
        loginSuccess = true;
      });
      userAccount.setAccount(res[0].username, res[0].password, res[0].scores);
    }
  }

  List<String> users = new List.filled(0, "", growable: true);
  List<double> highScores = new List.filled(0, 0, growable: true);

  void getHighScores() async {
    final dio = Dio();	// Http client
    final client = RestClient(dio);

    var res = await client.getAllHighscores();
    users.add(res[0].data['username'].toString());
    highScores.add(double.parse(res[0].data['highScore'].toString()));
    print(users[0]);
    print(highScores[0]);
  }

  void checkDuplicate() async {
    final dio = Dio();	// Http client
    final client = RestClient(dio);

    Map<String, String> req = {"username": "user1"};

    // res is a list of Map<String, dynamic>, and res[i].data is a map with a username and its highScore
    // res => [{'username': 'user1', 'highScore':287}, {'username' : 'user2', 'highScore':465}]
    // res[i].data = {'username': 'useri', 'highScore':123}
    var res = await client.checkUsername(req);
    if(res.length > 0){
      print("DUPLICATE!");
    }
    else {
      print(" N O DUPLICATE!");
    }
  }

  @override
  Widget build(BuildContext context) {

    var getHighscoresButton = ElevatedButton(
      child: Text('getHighScores'),
      onPressed: () {
        getHighScores();
      },
    );

    var usernameText = Visibility(
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("Your username: " + '$_username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        ),
        visible: loginSuccess);

    var usernameInput = Visibility(
        child: Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 200,
        child: TextFormField(
        controller: _usernameController,
        decoration: const InputDecoration(
          hintText: "Username",
          border: UnderlineInputBorder(),
        ),
        )),
        visible: !loginSuccess
    );

    var passwordInput = Visibility(
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          width: 200,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              border: UnderlineInputBorder(),
            ),
          ),
        ),
      visible: !loginSuccess,
    );


    var loginButton = Visibility(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ElevatedButton(
            child: Text('LOGIN'),
            onPressed: () {
              _username = _usernameController.text.toString();
              _password = _passwordController.text.toString();
              print("LOGIN pressed: " + _username + ", " + _password);
              checkUser();
            },
          ),
        ),
        visible: !loginSuccess);

    var loginFailText = Visibility(
      child: Text('Username or password is incorrect.', style: TextStyle(color: Colors.red)),
      visible: loginFail,
    );
    var leaderboardButton = ElevatedButton(
      child: Text('LeaderBoard'),
      onPressed: () {
        pauseMusic();
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return LeaderBoardRoute();
          }));
        },
    );

    var startButton = Visibility(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child:
            ElevatedButton(
              child: Text('START!'),
              onPressed: () {
                if(loginSuccess){
                  pauseMusic();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return SolveQuestionsRoute();
                  }));
                }},
            )),
        visible: loginSuccess);

    var form1Button = Visibility(
        child: Container(
            child:
            ElevatedButton(
              child: Text('Question form 1'),
              style: ElevatedButton.styleFrom(primary: colors[form1Color]),
              onPressed: () {
                userAccount.form = "OneNameMultipleYears";
                setState(() {
                  form1Color = 1;
                  form2Color = 0;
                });
                },
            )),
        visible: loginSuccess);

    var form2Button = Visibility(
        child: Container(
          padding: EdgeInsets.only(left: 5),
            child:
            ElevatedButton(
              child: Text('Question form 2'),
              style: ElevatedButton.styleFrom(primary: colors[form2Color]),
              onPressed: () {
                userAccount.form = "MultipleNamesOneYear";
                setState(() {
                  form1Color = 0;
                  form2Color = 1;
                });
              },
            )),
        visible: loginSuccess);

    var formButtons = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          form1Button,
          form2Button,
        ]);

    var createButton = Visibility(
        child: Container(
            padding: EdgeInsets.only(top: 10.0),
            child:
            ElevatedButton(
              child: Text('CREATE ACCOUNT'),
              onPressed: (){
                pauseMusic();
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (BuildContext context) => CreateAccountRoute(),
                ),
                );
              },
            )),
        visible: !loginSuccess);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            usernameText,
            usernameInput,
            passwordInput,
            loginFailText,
            loginButton,
            createButton,
            form1Button,
            form2Button,
            startButton,
            leaderboardButton,
            // Padding(
            //   padding: EdgeInsets.only( left: 100.0, right: 100.0),
            //   child:
            //   TextFormField(
            //     controller: _answerCountController,
            //     decoration: const InputDecoration(
            //       border: UnderlineInputBorder(),
            //       labelText: 'enter answer percentage (i.e. 0.5)',
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 10),
            //   child: ElevatedButton(
            //     child: Text('Final Screen'),
            //     onPressed: () {
            //       score = double.parse(_answerCountController.text);
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (BuildContext context) {
            //             return FinalRoute();
            //           }));
            //     },
            //   ),
            // ),
          ],
        ),
      ),

    );
  }
}


class FinalRoute extends StatefulWidget {
  @override
  _FinalRoute createState() => _FinalRoute();
}

class _FinalRoute extends State<FinalRoute>{
  @override
  Widget build(BuildContext context) {
  return new FinalPage(
  new BasicFinalPresenter(), title: 'Final Screen', score: score, key: Key("Sleep"),);
  }
}

class SolveQuestionsRoute extends StatefulWidget {
  @override
  _SolveQuestionsRoute createState() => _SolveQuestionsRoute();
}

class _SolveQuestionsRoute extends State<SolveQuestionsRoute>{
  @override
  Widget build(BuildContext context) {
    return new SolveQuestionsPage(
      new BasicSolveQuestionsPresenter(), title: 'Start name game', key: Key("Solve Questions"), user: userAccount);
  }
}

class LeaderBoardRoute extends StatefulWidget {
  @override
  _LeaderBoardRoute createState() => _LeaderBoardRoute();
}

class _LeaderBoardRoute extends State<LeaderBoardRoute>{
  @override
  Widget build(BuildContext context) {
    return new LeaderBoardPage(
      highscore: 100,user: 'user1', key: Key("LeaderBoard"),);

  }
}

class CreateAccountRoute extends StatefulWidget {
  @override
  _CreateAccountRoute createState() => _CreateAccountRoute();
}

class _CreateAccountRoute extends State<CreateAccountRoute>{
  @override
  Widget build(BuildContext context) {
    return new MyCreatePage(title: 'Create Account');
  }
}
