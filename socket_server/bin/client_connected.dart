import 'dart:io';

import 'socket_server.dart';

class ClientConnected{
  final List<int> clientPort = [];
  final List<Server> listServer = [];

  void addToList(int port){
    clientPort.add(port);
  }

  void showClientsConnect(){
    clientPort.forEach((element) {
      print(element.toString());
    });
  }

}