
import 'package:csv/csv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../api.dart';
import 'dart:math';
var now = new DateTime.now();
Random rnd = new Random();
Random rnd2 = new Random(now.millisecondsSinceEpoch);
int min = 0, max1 = 14, max2 = 6;
int r1 = min + rnd.nextInt(max1 - min);
int r2 = min + rnd.nextInt(max2 - min);
List<Map<String, String>> question1 = new List.filled(0, {}, growable: true);


class AutoQuestion {
  String? questionForm;
  AutoQuestion(this.questionForm);

  var staticquestions1 = [

{
  "question":"What year was the name Liam the most popular?",
  "a":"1988",
  "answer":"a",
  "b":"1978",
  "c":"1998",
  "d":"2008",
  "e":"2018",
},
{
  "question":"What year was the name Emma the most popular?",
  "a":"1895",
  "answer":"a",
  "b":"1885",
  "c":"1875",
  "d":"1905",
  "e":"1915",
},
{
  "question":"What year was the name Peggie the most popular?",
  "a":"1963",
  "b":"1943",
  "c":"1953",
  "answer":"c",
  "d":"1973",
  "e":"1983",
},
{
  "question":"What year was the name Tyree the most popular?",
  "a":"1987",
  "b":"1967",
  "c":"1977",
  "answer":"c",
  "d":"1957",
  "e":"1997",
},
{
  "question":"What year was the name Clayton the most popular?",
  "a":"1990",
  "b":"2000",
  "answer":"b",
  "c":"1980",
  "d":"2010",
  "e":"2020",
},
{
  "question":"What year was the name Olivia the most popular?",
  "a":"1945",
  "b":"1955",
  "answer":"b",
  "c":"1965",
  "d":"1975",
  "e":"1985",
},
{
  "question":"What year was the name Jamal the most popular?",
  "a":"1948",
  "b":"1958",
  "c":"1968",
  "answer":"c",
  "d":"1978",
  "e":"1988",
},
{
  "question":"What year was the name Leamon the most popular?",
  "a":"1887",
  "b":"1897",
  "c":"1907",
  "answer":"c",
  "d":"1917",
  "e":"1927",
},
{
  "question":"What year was the name Cecilia the most popular?",
  "a":"1845",
  "b":"1855",
  "c":"1865",
  "d":"1875",
  "e":"1885",
  "answer":"e",
},
{
  "question":"What year was the name Eli the most popular?",
  "a":"1979",
  "b":"1969",
  "c":"1959",
  "d":"1949",
  "e":"1939",
  "answer":"e",
},
{
  "question":"What year was the name Clyda the most popular?",
  "a":"1853",
  "b":"1863",
  "c":"1873",
  "d":"1883",
  "answer":"d",
  "e":"1893",
},
{
  "question":"What year was the name Trever the most popular?",
  "a":"1961",
  "b":"1971",
  "c":"1981",
  "d":"1991",
  "answer":"d",
  "e":"2001",
},
{
  "question":"What year was the name Wilford the most popular?",
  "a":"1943",
  "answer":"a",
  "b":"1953",
  "c":"1963",
  "d":"1973",
  "e":"1983",
},
{
  "question":"What year was the name Ezra the most popular?",
  "a":"1980",
  "answer":"a",
  "b":"1990",
  "c":"2000",
  "d":"2010",
  "e":"2020",
},
{
  "question":"What year was the name Melanie the most popular?",
  "a":"1969",
  "b":"1959",
  "c":"1949",
  "d":"1939",
  "answer":"d",
  "e":"1979",
},

];

  var staticquestions2 = [

  {
  "question":"Of these five names, which was the most popular in 2000?",
  "a":"Mikel",
  "answer":"a",
  "b":"Maximus",
  "c":"Kadin",
  "d":"Kirk",
  "e":"Heath",
},
    {
      "question":"Of these five names, which was the most popular in 1990?",
      "c":"Deven",
      "answer":"c",
      "b":"Derik",
      "a":"Amos",
      "d":"Kadin",
      "e":"Mikel",
    },
    {
      "question":"Of these five names, which was the most popular in 1980?",
      "d":"Aric",
      "answer":"d",
      "b":"Dilon",
      "c":"Nigel",
      "a":"Heat",
      "e":"Ezra",
    },
    {
      "question":"Of these five names, which was the most popular in 1970?",
      "e":"Katy",
      "answer":"e",
      "b":"Dilon",
      "c":"Kadin",
      "d":"Kirk",
      "a":"Derik",
    },
    {
      "question":"Of these five names, which was the most popular in 1960?",
      "d":"Kandy",
      "answer":"d",
      "b":"Dilon",
      "c":"Kadin",
      "a":"Amos",
      "e":"Nigel",
    },
    {
      "question":"Of these five names, which was the most popular in 1950?",
      "c":"Emory",
      "answer":"c",
      "b":"Melanie",
      "a":"Kadin",
      "d":"Kirk",
      "e":"Katy",
    },
    {
      "question":"Of these five names, which was the most popular in 1940?",
      "a":"Carson",
      "answer":"a",
      "b":"Emory",
      "c":"Kadin",
      "d":"Deven",
      "e":"Derik",
    },

  ];
  Map getQuestions() {
    int nextR1 = min + rnd.nextInt(max1 - min);
    int nextR2 = min + rnd.nextInt(max2 - min);

    if(questionForm == "OneNameMultipleYears") {
      while(r1 == nextR1) {
        nextR1 = min + rnd.nextInt(max1 - min);
      }
      r1 = nextR1;
      print('Got question type: $questionForm');
      return staticquestions1[r1];
    }
    //if(questionForm == "MultipleNamesOneYear")
    else {
      while(r2 == nextR2) {
        nextR2 = min + rnd.nextInt(max2 - min);
      }
      r2 = nextR2;
      print('Got question type: $questionForm');
      return staticquestions2[r2];
    }
  }
}

