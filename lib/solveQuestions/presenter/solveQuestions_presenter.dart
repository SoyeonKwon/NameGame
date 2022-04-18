
import 'package:name_game/solveQuestions/views/solveQuestions_view.dart';

class SolveQuestionsPresenter {
  //set calendarView(calendarSleepDetailsView value) {}
  set solveQuestionsView(SolveQuestionsView value) {}
}

class BasicSolveQuestionsPresenter implements SolveQuestionsPresenter {
  SolveQuestionsView _view = new SolveQuestionsView();

  @override
  set solveQuestionsView(SolveQuestionsView value){
    _view = value;
  }

  BasicSolveQuestionsPresenter() {

  }

}
