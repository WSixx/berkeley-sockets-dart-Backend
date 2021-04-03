import 'dart:io';
import 'dart:typed_data';

import 'socket_server.dart';


class ServerWorker{
  Server server;
  Socket clientSocket;
  var outputStream;
  Stdout stdout;
  Stdin stdin;
  String login = '';


  ServerWorker(Server server, Socket clientSocket){
    this.server = server;
    this.clientSocket = clientSocket;
    handleConnection(clientSocket);
  }


  void handleConnection(Socket client) {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    var text = stdin.readLineSync();
    //  stdout =  clientSocket.read;
    client.isBroadcast;
    client.listen(
          (Uint8List data) async {
        while(text != null){
            var message = String.fromCharCodes(data);
          if('logoff' == message || 'quit' == message){
           handleLogoff(client);
           print('logoff');
           return;
         }else if (message.startsWith('login')){
           handleLogin(client, message);
         } else if(message.startsWith('msg')){
            await handleMessage(message);
         }else if('join' == message){
           //handleJoin(tokens);
         } else if('leave' == message){
           //handleLeave(tokens);
         }
         else{
           var errorMsg = 'Unknow ' + message;
            clientSocket.write(errorMsg);
         }
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

  Future<void> handleMessage(String message) async {
    print('Entrou em handle Message');
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++)
        i: split[i]
    };

    //boolean isTopic = sendTo.charAt(0) == '#';
    var isTopic = true;
    var sendTo = values[1];
    var body = values[2];

    var workerList = server.getWorkerList();
    for (var worker in workerList){
/*  if(isTopic){
  if(worker.isMemberOfTopic(sendTo)){
  String outMsg = "msg: " + sendTo + ":" + login + ": " + body + "\n";
  worker.send(outMsg);
  }
  }else{*/
      if(sendTo.contains(worker.getLogin())){
        print('Entrou aqui');
        var outMsg = 'msg ' + login + ' ' + body + '\n';
        worker.send(clientSocket, outMsg);
      }
    }
  }

  void handleLogin(Socket client, String message) {
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++)
        i: split[i]
    };
    var login = values[1];
    var password = values[2];
    if ((login == 'lucas' && password == '123') ||
        (login == 'guest' && password == 'guest')) {
      var msg = 'Ok login';
      clientSocket.write(msg);
      this.login = login;
      print('Usuario logado com  sucesso ' + login);
      var workerList = server.getWorkerList();
      //Send current user all other online
      for (var worker in workerList) {
        if (worker.getLogin() != null) {
          if (!login.contains(worker.getLogin())) {
            var msg2 = 'online ' + worker.getLogin() + '\n';
            send(clientSocket, msg2);
          }
        }
      }
      // send when other user is online
      var onlineMsg = 'online ' + login + '\n';
      for (var worker in workerList) {
        if (!login.contains(worker.getLogin())) {
          worker.send(clientSocket, onlineMsg);
        }
      }
    } else {
      var msg = 'Error login\n';
      client.write(msg);
      print('Login Failed for: ' + login);
      }
  }

  void handleLogoff(Socket client) {
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