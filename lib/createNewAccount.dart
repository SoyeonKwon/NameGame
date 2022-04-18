import 'package:flutter/material.dart';
import 'package:name_game/solveQuestions/presenter/solveQuestions_presenter.dart';
import 'package:name_game/solveQuestions/views/solveQuestions_component.dart';
import 'final_screen/presenter/final_presenter.dart';
import 'final_screen/views/final_component.dart';
import 'package:just_audio/just_audio.dart';
import 'main.dart';
import 'user.dart';
import 'package:dio/dio.dart';
import '../../api.dart';


class MyCreatePage extends StatefulWidget {
  MyCreatePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _createAccountPage createState() => _createAccountPage();
}

class _createAccountPage extends State<MyCreatePage> {
  late TextEditingController _answerCountController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isCreated = false;
  bool duplicate = false;
  bool empty = false;
  //bool loginFail = false;
  String _username = '';
  String _password = '';

  Future<bool> isNotDuplicate() async {
    final dio = Dio();	// Http client
    final client = RestClient(dio);

    Map<String, String> req = {"username": _username};

    var res = await client.checkUsername(req);
    if(res.length > 0){
      print("DUPLICATE!");
      setState(() {
        duplicate = true;
      });
      return false;
    }
    else {
      print(" N O DUPLICATE!");
      setState(() {
        isCreated = true;
        duplicate = false;
      });
      Map<String, String> req2 = {"username": _username, "password": _password};
      client.insertNewUser(req2);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var usernameText = Visibility(
        child: Text("Your username is: " + '$_username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        visible: isCreated);

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
        visible: !isCreated
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
      visible: !isCreated,
    );

    var createButton =Visibility(
        child:
    Container(
      padding: EdgeInsets.only(top: 10),
      child: ElevatedButton(
        child: Text('Create'),
        onPressed: () {
          _username = _usernameController.text.toString();
          _password = _passwordController.text.toString();

          if(_username.isNotEmpty && _password.isNotEmpty) {
            setState(() {
              empty = false;
            });
            isNotDuplicate().then((dupResult) {
              setState(() {
                isCreated = dupResult;
              });
            });
          }
          else {
            setState(() {
              empty = true;
            });
          }

          //PUT A FUNCTION THAT CHECKS DUPLICATE & INSERT NEW ACCOUNT IN THE DB
        },
      ),),
        visible: !isCreated);

    var backtoHomeButton = Visibility(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ElevatedButton(
          child: Text('Go to Main'),
          onPressed: () {
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
      visible: isCreated,
    );

    var isCreatedFailText = Visibility(
      child: Text('Username or password is in use, please choose a different one.',
          style: TextStyle(color: Colors.red, fontSize: 18)),
      visible: duplicate,
    );

    var emptyFieldText = Visibility(
      child: Text('Please fill both username and password.',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18)),
      visible: empty,
    );


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
            isCreatedFailText,
            emptyFieldText,
            createButton,
            backtoHomeButton,
          ],
        ),
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


class HomePageRoute extends StatefulWidget {
  @override
  _HomePageRoute createState() => _HomePageRoute();
}

class _HomePageRoute extends State<HomePageRoute>{
  @override
  Widget build(BuildContext context) {
    return new MyHomePage(title:'Home Page');
  }
}