/*
Padding(
              padding: EdgeInsets.only(top: 20.0),
              child:
              ElevatedButton(
                child: Text('Sleep'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return SolveQuestionsRoute();
                  }));
                },
              ),
),



class SolveQuestionsRoute extends StatefulWidget {
  @override
  _SolveQuestionsRoute createState() => _SolveQuestionsRoute();
}

class _SolveQuestionsRoute extends State<SolveQuestionsRoute>{
  @override
  Widget build(BuildContext context) {
    return new SolveQuestionsPage(
      new BasicSolveQuestionsPresenter(), title: 'Start name game', key: Key("Solve Questions"),);
  }
}


quiver: ^3.0.1+1
liquid_progress_indicator: ^0.4.0



* */