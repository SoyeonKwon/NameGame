# autoquestion helper
import csv
import random

print(
'''
import 'package:csv/csv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../api.dart';
import 'dart:math';
var now = new DateTime.now();
Random rnd = new Random();
Random rnd2 = new Random(now.millisecondsSinceEpoch);
int min = 0, max = 69;
int r = min + rnd.nextInt(max - min);
class AutoQuestion {
  String? questionForm;
  AutoQuestion(this.questionForm);
  var staticquestions = [
'''
)

with open('autoquestion-data.csv', newline='') as csvfile:
	spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
	for row in spamreader:
		
		year = row[0]
		female = row[2]
		male = row[6]
		wrongyear = []
		wrongyear.append(int(year) + 10)
		wrongyear.append(int(year) + 5)
		wrongyear.append(int(year))
		wrongyear.append(int(year) - 5)
		wrongyear.append(int(year) - 10)
		random.shuffle(wrongyear)
		letters = ['a','b','c','d','e']

		print("{");
		print("  \"question\":\"What year was the name " + male + " the most popular?\",")
		for i in range(0, 5):
			print("  \"" + letters[i] + "\":\"" + str(wrongyear[i]) + "\",")
			#print("year: " + str(year) + " - wrongyear: " + str(wrongyear[i]))
			if int(wrongyear[i]) == int(year):
				print("  \"answer\":\"" + letters[i] + "\",")
		print("},");
		print("{");
		print("  \"question\":\"What year was the name " + female + " the most popular?\",")
		for i in range(0, 5):
			print("  \"" + letters[i] + "\":\"" + str(wrongyear[i]) + "\",")
			#print("year: " + str(year) + " - wrongyear: " + str(wrongyear[i]))
			if int(wrongyear[i]) == int(year):
				print("  \"answer\":\"" + letters[i] + "\",")
		print("},");


print(
'''
];
  Map getQuestions() {
    if(questionForm == "OneNameMultipleYears") {
      print('Got question type: $questionForm');
      return staticquestions[r];
    }
    if(questionForm == "MultipleNamesOneYear") {
      print('Got question type: $questionForm');
      return staticquestions[1];
    }
    print('Sending Random');
    return staticquestions[r];

  }
}
'''
)