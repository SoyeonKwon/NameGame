import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api.g.dart';

// If you're using LOCALHOST for the node server and Android emulator, ONLY CHANGE PORT #.
// Android emulator uses the 10.0.2.2 address to connect to your computer's localhost.
// IOS Emulator/Physical and Android Physical will be different.


@RestApi(baseUrl: "https://api.sixyoungpeople.com/")
//@RestApi(baseUrl: "http://10.0.2.2:3000/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/getRandomAnswer")
  Future<List<Collection>> getRandomAnswer();

  @POST("/checkUsername")
  Future<List<UserCollection>> checkUsername(@Body () Map<String, String> object);

  @GET("/getAllHighscores")
  Future<List<HighScore>> getAllHighscores();

  @POST("/findOneUser")
  Future<List<UserCollection>> findOneUser(@Body () Map<String, String> object);

  @POST("/insertNewUser")
  Future<String> insertNewUser(@Body () Map<String, String> object);

  @POST("/insertScore")
  Future<String> insertScore(@Body () Map<String, dynamic> object);

  @POST("/updateHighScoreAndDate")
  Future<String> updateHighScoreAndDate(@Body () Map<String, dynamic> object);
}

@JsonSerializable()
class Collection {
  @JsonKey(name: '_id')
  List<dynamic> things;

  Collection({required this.things});

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}

@JsonSerializable()
class UserCollection {
  @JsonKey(name: '_id')
  String username;
  String password;
  List<Map<String, dynamic>> scores = List.filled(0, {}, growable: true);

  UserCollection({required this.username, required this.password, required this.scores});

  factory UserCollection.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> jsonScores = List.filled(0, {}, growable: true);
    for(dynamic v in json['scores']){
      jsonScores.add({"score":v["score"], "date":v["date"]});
    }
    return UserCollection(
      username: json['username'],
      password: json['password'],
      scores: jsonScores,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password' : password,
      'scores' : scores
    };
  }
}

@JsonSerializable()
class HighScore{
  Map<String, dynamic> data = {'username' : "", 'highScore':0};

  HighScore({required this.data});

  factory HighScore.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonHighscore = {'username' : "", 'highScore':0};
    jsonHighscore['username'] = json['username'];
    jsonHighscore['highScore'] = json['highScore'];
    return HighScore(data: jsonHighscore);
  }
}
