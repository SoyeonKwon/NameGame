var express = require('express')
var mongojs = require('mongojs')
var app = express()
var db = require('./myDB.js')

app.use(express.json())
app.get('/', (req, res) => {
	console.log("HELLO");
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.end('special sixyoungpeople sweetdreams api server - pushtest');
})

app.post('/findMostPopular1', (req, res) => {
    db.findMostPopular1(req, function (docs) {
        res.send(docs)
    });
})

app.get('/getAllHighscores', (req, res) => {
    db.getAllHighscores(function (docs) {
        console.log("sleepDetails(test1): ", docs);
        res.send(docs)
    });
})

app.post('/getRandomAnswer', (req, res) => {
    db.getRandomAnswer(function (docs) {
        res.send(docs)
    });
})

app.post('/checkUsername', (req, res) => {
    db.checkUsername(req, function (docs) {
        res.send(docs)
    });
})

app.post('/findOneUser', (req, res) => {
    db.findOneUser(req, function (docs) {
        res.send(docs)
    });
})

app.post('/insertScore', (req, res) => {
    db.insertScore(req);
    res.send(req.body);
})

app.post('/insertNewUser', (req, res) => {
    db.insertNewUser(req);
    //res.send(req.body);
})

app.post('/findHighScore', (req, res) => {
    db.findHighScore(req, function (docs) {
        res.send(docs)
    });
})

app.post('/findDateofHighScore', (req, res) => {
    db.findDateofHighScore(req, function (docs) {
        res.send(docs)
    });
})

app.post('/updateHighScoreAndDate', (req, res) => {
    if (req.body) {
        db.updateHighScoreAndDate(req);
    }
    res.send(req.body);
})



app.listen(3000, ()=>console.log("listening"));
