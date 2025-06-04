let http = require('http')
let ws = require('ws')
let fs = require('fs')

function handler(req, res)
{
    const path = req.url // we get the file path, it always starts with "/"
    console.log("--> " + path)


    let filename;
    if (path === "/") {
        filename = "index.html"
    }
    else {
        filename = path.substring(1)
    }

    if (!fs.existsSync(filename)) {
        res.end();
        return;
    }
    console.log("-- Sending back the contents of "+filename)
    let contents = fs.readFileSync(filename)
    res.end(contents);
}




function new_ws_connection(ws) {
    ws.on('message', function message(json_string) {
        console.dir(json_string)
        let data = JSON.parse(json_string);
        console.dir(data)
        let username = data.user // We get the username from the data sent by the client
        let response = { from: 'server', message: 'Welcome ' + username}
        
        // We transform the response data to JSON and send them to the client:
        let json_response = JSON.stringify(response)
        ws.send(json_response);

    });

    ws.on('close', function() {
        console.log("ws closed");
    });

}

let server = http.createServer(handler)

const ws_server = new ws.WebSocketServer({ server, path: "/chat" });

ws_server.on('connection', new_ws_connection);


server.listen(8080)

console.log('Server starting')