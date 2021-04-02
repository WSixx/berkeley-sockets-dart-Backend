import 'dart:io';

import 'dart:typed_data';

import 'client_connected.dart';
import 'server_worker.dart';

void main() async {
  var server = Server(3320);
  await server.connect();
}

class Server{

  List<ServerWorker> workerList = [];
  int serverPort;

  Server(int serverPort) {
    this.serverPort = serverPort;
  }

  List<ServerWorker> getWorkerList(){
    return workerList;
  }

  Future<void> connect() async {
    final clientConnected = ClientConnected();
    // bind the socket server to an address and port
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3320);

    // listen for clent connections to the server
      server.isBroadcast;
      server.listen((client) {
        //handleConnection(client,clientConnected);
        print('Conexão aceita ' + client.remotePort.toString());
        var worker = ServerWorker(this, client);
        workerList.add(worker);
      });
  }

  void removeWorker(ServerWorker serverWorker) {
    workerList.remove(serverWorker);
  }

}

