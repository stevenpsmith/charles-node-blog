var express = require('express');
var app = express();
var connectTimeout = require('connect-timeout');
var timeout = connectTimeout({ time: 10 });

var errorJson = {error:"API Error",error_msg:"You have encountered an error thanks to Charles and Node....have a nice day!"};

app.get('/weather', function(req, res) {
  	res.json(400, errorJson);
});

app.get('/foo', timeout, function(req, res){
	res.send(408, "Request timed out...shucks");
});

app.listen(process.env.PORT || 4730);
