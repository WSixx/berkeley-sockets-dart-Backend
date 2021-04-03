
import 'dart:io';

Socket socket;

void main() {
  Socket.connect('localhost', 3320)
      .then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  })
      .catchError((e) {
    print('Unable to connect: $e');
    exit(1);
  });

  //Connect standard in to the socket
  stdin.listen((data) =>
      socket.write(
          String.fromCharCodes(data).trim() + '\n'));
}

void dataHandler(data){
  print(String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  print(error);
}

void doneHandler(){
  socket.destroy();
  exit(0);
}