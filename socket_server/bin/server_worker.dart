import 'dart:io';
import 'dart:typed_data';

import 'socket_server.dart';

class ServerWorker{
  Server server;
  Socket clientSocket;
  var outputStream;
  final String login = '';


  ServerWorker(Server server, Socket clientSocket){
    this.server = server;
    this.clientSocket = clientSocket;
    handleConnection(clientSocket);
  }

  void handleConnection(Socket client) {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    client.isBroadcast;
    client.listen(
          (Uint8List data) async {
            final message = String.fromCharCodes(data);
        if('logoff' == message || 'quit' == message){
          handleLogoff();
          print('entrou logoff');
          return;
        }else if (message.startsWith('login')){
          handleLogin(clientSocket, message);
        } else if('msg' == message){
         // String[] tokensMsg = StringUtils.split(line, null, 3);
          //handleMessage(tokensMsg);
        }else if('join' == message){
          //handleJoin(tokens);
        } else if('leave' == message){
          //handleLeave(tokens);
        }
        else{
          var errorMsg = 'Unknow ' + message + '\n';
         // outputStream.write(errorMsg.getBytes());
        }
      },

      // handle errors
      onError: (error) {
        print(error);
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        client.close();
      },
    );
  }

  void handleLogin(outputStream, String message) {
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++)
        i: split[i]
    };
      var login = values[1];
      var password = values[2];
      if(login == 'lucas' && password == '123'){
          var msg = 'Ok login\n';
          outputStream.write(msg);
      }
      print(login + ' ' + 'password ' + password);

  }

  void handleLogoff() {
    server.removeWorker(this);
    var workerList = server.getWorkerList();
    var onlineMsg = 'offline ' + login + '\n';

    for(var work in workerList){
      if(!login.contains(work.getLogin())){
        work.send(clientSocket, onlineMsg);
      }
    }
    clientSocket.close();
  }

  String getLogin() {
    return login;
  }

  void send(Socket socket, String msg) {
  if(login != null){
    socket.write(msg);
  }
}



}