import 'dart:io';

import 'chat_client.dart';

ServerSocket server;
List<ChatClient> clients = [];

List<ChatClient> getChatList(){
  return clients;
}


void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3320)
      .then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client){
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');

  clients.add(ChatClient(client));

  client.write('Welcome to dart-chat! '
      'There are ${clients.length - 1} other clients\n');
}