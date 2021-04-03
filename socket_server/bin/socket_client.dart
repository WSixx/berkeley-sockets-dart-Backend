import 'dart:io';
import 'dart:typed_data';

import 'server_worker.dart';

void main() async {

  ServerWorker serverWorker;

  // connect to the socket server
  final socket = await Socket.connect('localhost', 3320);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // listen for responses from the server
    socket.listen(
      // handle data from the server
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
        serverWorker.handleConnection(socket);
      },

      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        //socket.destroy();
      },
    );

    // send some messages to the server
  while(true){
    var text = stdin.readLineSync();
    if(text == 'logoff'){
      // socket.destroy();
      return;
    }
    serverWorker.send(socket, text);
    //await sendMessage(socket, text);
  }

}

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  socket.write(message);
}