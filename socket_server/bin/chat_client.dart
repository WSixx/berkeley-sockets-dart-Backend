import 'dart:io';

import 'dart:math';

ServerSocket server;


void main() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3320);

    // listen for clent connections to the server
      server.listen((event) {
        var chatClient = ChatClient(event);
        chatClient.handleConnection(event);
      });



  /*  server.listen((client) {
      var chatClient = ChatClient(client);
     chatClient.handleConnection(client);
      print('Conexão aceita');
    });*/
  }

class ChatClient{
  Socket _socket;
  String _address;
  int _port;

  List<ChatClient> clients = [];


  ChatClient(Socket s){
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.asBroadcastStream(onListen: (subscription) {
      messageHandler;
      //onError: errorHandler;
      //onDone: finishedHandler;
    },);

  }


  void handleConnection(Socket client){
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');

    clients.add(ChatClient(client));

    client.write('Welcome to dart-chat! '
        'There are ${clients.length} other clients\n');
  }

  void messageHandler(dynamic data){
    var message = String.fromCharCodes(data).trim();
    distributeMessage(this, '$_address:$_port Message: $message');
  }

  void errorHandler(error){
    print('$_address:$_port Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('$_address:$_port Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message){
    _socket.write(message);
  }

  void distributeMessage(ChatClient client, String message){
    for (var c in clients) {
      if (c != client){
        c.write(message + '\n');
      }
    }
  }

  void removeClient(ChatClient client){
    clients.remove(client);
  }

}

