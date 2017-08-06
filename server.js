#!/usr/bin/env node

var exec = require('child_process').exec;
var spawn = require('child_process').spawn;

var express = require('express');
var multer  = require('multer')
var url = require('url');

//
const port = process.env.PORT || '8080';
const secret = process.env.SECRET_KEY;

//
var app = express();

//auth
app.use((req, res, next) => {
    console.log(req.headers);

    var u = url.parse(req.url, true);
    var key = u.query['key'];
    if (key == secret) {
        next();
    } else {
        res.status(401).send('Invalid key')
        console.log('*** unauthorized');
    }
})

app.post('/run', multer({ dest: './temp/'}).single('file'), (req,res) => {
    var tid=req.file.filename+'>';

    console.log('%s @@@@@@', tid)
	console.log('%s %o', tid, req.body);
	console.log('%s ------', tid)
	console.log('%s %o', tid, req.file);
	console.log('%s ------', tid)

	var c = './run.sh ' + req.file.destination + ' ' + req.file.filename + ' ' + req.body.args;
	console.log('%s Running: %s', tid, c)

    res.writeHead(200, {
        "Content-Type": "text/plain"
    });

	var p = spawn(c, {
        shell: true
    });

    p.stdout.on('data', (data) => {
        res.write(tid + data);
        console.log('%s stdout: %s', tid, data);
    });

    p.stderr.on('data', (data) => {
        res.write(tid + data);
        console.log('%s stderr: %s', tid, data);
    });

    p.on('exit', (code) => {
        //send status code as last line in response
        var s = tid + ' ###### exit status:\n' + code;
        res.write(s);
        res.end();
        console.log(s)
    });

});

app.get('/sh', (req, res) => {
    var u = url.parse(req.url, true);
    var cmd = u.query['cmd'];

    if (cmd) {
        exec(cmd, function (error, stdout, stderr) {
            res.status(error ? 500 : 200).send(
                '\nerror: '+ error +
                '\nstdout: ' + stdout +
                '\nstderr: ' + stderr +
                '\ndate: ' + new Date() +
                '\n'
            )
        });
    } else {
        res.status(400).send('Missing params')
    }
});

app.listen(port, () => {
    console.log('Server listening on: ', port);
});