var express = require('express');
var app = express();
app.get('/',function(res,req){
  res.send('Hello world(test2)!\n');
})
var port = 80;
app.listen(port);
console.log('Listening on port', port);
