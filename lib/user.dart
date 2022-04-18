import 'package:intl/intl.dart';


class Account {

  String username = "";
  String password = "";
  String form = "OneNameMultipleYears";
  List<Map<String, dynamic>> scores = new List.filled(0, {}, growable: true);
  double highScore = 0;
  DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss a');

  setAccount(String username, String password, List<Map<String, dynamic>> scores) {
    this.username = username;
    this.password = password;
    if(scores.length > 0) {
      this.scores = scores;
      for(Map<String, dynamic> s in this.scores){
        print(s['date']);
        DateTime aDate = inputFormat.parse(s['date']);
        s['date'] = aDate;
      }
      if(scores.length > 0) {
        for(int i = 0; i < scores.length; i++){
          if(highScore < scores[i]['score']){
            print(scores[i]['score']);
            highScore = scores[i]['score'];
          }
        }
      }
      else this.highScore = 0;
      print("highScore in Account: " + this.highScore.toString());
    }
    print(scores);
  }

  //
  // void updateScore(DateTime date, double score) {
  //     highScore = {date : score};
  // }

 // bool operator==(dynamic other) {
 //    return username == other.username;
 // }
}