let http = require('http')
let ws = require('ws')
let fs = require('fs')

function handler(req, res)
{
    let contents = fs.readFileSync('echo-test.html')
    res.end(contents);
}

let server = http.createServer(handler)

const ws_server = new ws.WebSocketServer({ server, path: "/chat" });

let sockets = new Set();

ws_server.on('connection', function connection(ws) {
    sockets.add(ws);

    ws.on('message', function message(data, isBinary) {
        console.log('received: %s', data);
        // Broadcast to all connected sockets
        sockets.forEach(function each(client) {
            if (client.readyState === ws.OPEN) {
                client.send(data, {binary: isBinary});
            }
        });
    });

    ws.on('close', function() {
        console.log("ws closed");
        sockets.delete(ws);
    });

    ws.send('something');
});

server.listen(8080)
console.log('Server starting')