import 'dart:io';
import 'dart:async';
import 'dart:isolate';

void job(SendPort sendPort) {
  ReceivePort receiverPort = ReceivePort();
  sendPort.send(receiverPort.sendPort);

  receiverPort.listen((data) {
    print('From Main: $data');
    // if(data == 'Hi'){
    //   sendPort.send('Hello');
    // } else if(data == 'Good Morning!'){
    //   sendPort.send('Very Good Morning!!');
    // }

    if(data == 'Good Morning!'){
      sendPort.send('Very Good Morning!!');
    }
  });

  sendPort.send('Hello');
}

void main() async {
  Completer completer = Completer<SendPort>();
  ReceivePort fromIsolate = ReceivePort();
  Isolate isolate = await Isolate.spawn(job, fromIsolate.sendPort);

  SendPort toIsolate;
  fromIsolate.listen((data) async {
    if (data is SendPort) {
      completer.complete(data);
      toIsolate = await completer.future;
      // toIsolate.send('Hi');
    } else {
      print('From Isolate: $data');
      if(data == 'Hello'){
        toIsolate.send('Good Morning!');
      }
    }
  });

  await Future.delayed(Duration(seconds: 5));
  isolate.kill();
  fromIsolate.close();
}