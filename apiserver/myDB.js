const mongojs = require('mongojs'); //imports 'mongojs'
const assert = require('assert'); //Assertion for queries
// Connection URL
const url = "mongodb://sixyoungpeople:sixyoungpasswords@localhost:27017/cs3541";
//const url = "mongodb://localhost:27017/lab6";
//URL with database included for local mongo db
// Database Name
const collections = ["FinalExamFullDataDetails", "FinalExamUsers", "FinalExamHighScores"];
//list of collections that you will be accessing.
mongodb = mongojs(url, collections);
module.exports = {

    getRandomAnswer: function (callback) {
        var cursor = mongodb.collection("FinalExamFullDataDetails").find({}).limit(1, function(err, docs){

            if (err || !docs) {
                console.log("Cannot print database or database is empty\n");
            }
            else {
                //console.log(collectionName, docs);

                callback(docs);
            }
        });

    },

    insertNewUser: function (userInfo, callback) {
        var cursor = mongodb.collection("FinalExamUsers").insert({
            username: userInfo.body.username,
            password: userInfo.body.password,
            scores: []
        }, function (err, docs) {
            if (err || !docs) {
                console.error(err);
            }
            else {
                console.log(userInfo.body);
            }
        });
    },

    insertScore: function (userScoreInfo, callback) {
        var cursor = mongodb.collection("FinalExamUsers").update(
            {
                username: userScoreInfo.body.username
            },
            {
                $push: {
                scores:
                    {
                        score: userScoreInfo.body.score,
                        date: userScoreInfo.body.date
                    }
                    }
            },
            function (err, docs) {
                if (err || !docs) {
                    console.error(err);
                }
                else {
                    console.log(" Score inserted ");
                }
            });
    },

    findHighScore: function (usernameInfo, callback) {
        var cursor1 = mongodb.collection("FinalExamUsers").aggregate([
            {
                $match: { username: usernameInfo.body.username}
            },
            { $unwind: "$scores" },
            {
                $group: {
                    "_id" : "$_id",
                    "highScore": { $max: "$scores.score" },
                }
            }],
            function (err, docs) {
                if (err || !docs) {
                    console.error(err);
                }
                else {
                    console.log("findHighScore called");
                    callback(docs);
                }
            }
        );
    },

    findDateofHighScore: function (userInfo, callback) {
        var cursor = mongodb.collection("FinalExamUsers").aggregate([
            { $match: { username: userInfo.body.username } },
            { $unwind: "$scores" },
            { $match: { "scores.score": userInfo.body.highScore } },
            {
                $group: {
                    "_id": "$_id",
                    "dateOfHighScore": { $first: "$scores.date" },
                }
            }],
            function (err, docs) {
                if (err || !docs) {
                    console.error(err);
                }
                else {
                    callback(docs);
                }
            });
    },

    updateHighScoreAndDate: function (highscoreInfo, callback) {
        var cursor = mongodb.collection("FinalExamHighScores").update(
            { username: highscoreInfo.body.username },
            {
                $set: {
                    highScore: highscoreInfo.body.highScore,
                    date: highscoreInfo.body.date
                }
            },
            { upsert: true },
            function (err, docs) {
            if (err || !docs) {
                console.error(err);
            }
            else {
                console.log(highscoreInfo.body);
            }
        });
    },

    findOneUser: function (userInfo, callback) {
        var cursor = mongodb.collection("FinalExamUsers").find({
            username: userInfo.body.username,
            password: userInfo.body.password},
            function (err, docs) {
                if (err) {
                    console.error(err);
                }
                else {
                    callback(docs);
                }
            });
    },

    getAllHighscores: function (callback) {
        var cursor = mongodb.collection("FinalExamHighScores").aggregate([{ $project: { "date": 0 } }], 
            function (err, docs) {

            if (err || !docs) {
                console.log("Cannot print database or database is empty\n");
            }
            else {
                callback(docs);
            }
        });
    },

    checkUsername: function (newAccount, callback) {
        var cursor = mongodb.collection("FinalExamUsers").find({
            username: newAccount.body.username
        }, function (err, docs) {
            if (err) {
                console.error(err);
            }
            else {
                callback(docs);
            }
        });
    },

    findMostPopular1: function (nameInfo, callback) {
        var cursor = mongodb.collection("FinalExamFullDataDetails").find({ name: nameInfo.body.name })
            .sort({ percent: -1 }).limit(1, function (err, docs) {
            if (err || !docs) {
                console.error(err);
            }
            else {
                callback(docs);
            }
        });
    },
};
