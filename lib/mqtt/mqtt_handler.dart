// /*
//  * Package : mqtt_client
//  * Author : S. Hamblett <steve.hamblett@linux.com>
//  * Date   : 31/05/2017
//  * Copyright :  S.Hamblett
//  */

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:lovebug/data/models/lovebug.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// /// An annotated simple subscribe/publish usage example for mqtt_server_client. Please read in with reference
// /// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
// /// files for separate subscribe/publish tests.

// /// First create a client, the client is constructed with a broker name, client identifier
// /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
// /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
// /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
// /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
// /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
// /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
// /// of 1883 is used.
// /// If you want to use websockets rather than TCP see below.
// class MQTTHandler {
  
//   final client = MqttServerClient('24.199.84.80', '');

//   var pongCount = 0; // Pong counter

//   Future<int> setUpMqtt() async {
//     late Lovebug lovebug;
//     client.logging(on: true);

//     client.setProtocolV311();
//     client.keepAlivePeriod = 20;
//     client.connectTimeoutPeriod = 2000; // milliseconds
//     client.onDisconnected = onDisconnected;
//     client.onConnected = onConnected;
//     client.onSubscribed = onSubscribed;
//     client.pongCallback = pong;

//     final connMess = MqttConnectMessage()
//         .withClientIdentifier('Mqtt_MyClientUniqueId')
//         .withWillTopic('willtopic') // If you set this you must set a will message
//         .withWillMessage('My Will message')
//         .startClean() // Non persistent session for testing
//         .withWillQos(MqttQos.atLeastOnce);

//     client.connectionMessage = connMess;

//     try {
//       await client.connect();
//     } on NoConnectionException catch (e) {
//       print('EXAMPLE::client exception - $e');
//       client.disconnect();
//     } on SocketException catch (e) {
//       print('EXAMPLE::socket exception - $e');
//       client.disconnect();
//     }

//     if (client.connectionStatus!.state == MqttConnectionState.connected) {
//       print('EXAMPLE::Mosquitto client connected');
//     } else {
//       print(
//           'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
//       client.disconnect();
//       exit(-1);
//     }

//     const topic = 'lovebug'; // Not a wildcard topic
//     client.subscribe(topic, MqttQos.atMostOnce);

//     const topic2 = 'lovebug-mobile-stbd-fan-mode-cmd'; // Not a wildcard topic

//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
//       final recMess = c![0].payload as MqttPublishMessage;
    
//       final pt =
//           MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          
//           if(c[0].topic == 'lovebug') {
//               lovebug = Lovebug.fromJson(json.decode(pt as String));
//               print(lovebug.ventilation.toJson());
//               if(lovebug.ventilation.stbdAft.direction == 1) {
//                 // final builder = MqttClientPayloadBuilder();
//                 //  builder.addString("5");
//                 //  await client.publishMessage(topic2, MqttQos.exactlyOnce, builder.payload!);
//               }
//           }
          
//       // print(
//       //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//       // print('');
//     });
//     client.published!.listen((MqttPublishMessage message) {
//       print(
//           'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
//     });

//     /// Lets publish to our topic
//     /// Use the payload builder rather than a raw buffer
//     /// Our known topic to publish to
//     const pubTopic = 'Dart/Mqtt_client/testtopic';
//     final builder = MqttClientPayloadBuilder();
//     builder.addString('Hello from mqtt_client');

//     /// Subscribe to it
//     print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
//     client.subscribe(pubTopic, MqttQos.exactlyOnce);

//     /// Publish it
//     print('EXAMPLE::Publishing our topic');
//     client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

//     /// Ok, we will now sleep a while, in this gap you will see ping request/response
//     /// messages being exchanged by the keep alive mechanism.
//     print('EXAMPLE::Sleeping....');
//     //await MqttUtilities.asyncSleep(60);

//     /// Finally, unsubscribe and exit gracefully
//     print('EXAMPLE::Unsubscribing');
//     //client.unsubscribe(topic);

//     /// Wait for the unsubscribe message from the broker if you wish.
//     //await MqttUtilities.asyncSleep(2);
//     print('EXAMPLE::Disconnecting');
//     //client.disconnect();
//     print('EXAMPLE::Exiting normally');
//     return 0;
//   }

//   /// The subscribed callback
//   void onSubscribed(String topic) {
//     print('EXAMPLE::Subscription confirmed for topic $topic');
//   }

//   /// The unsolicited disconnect callback
//   void onDisconnected() {
//     print('EXAMPLE::OnDisconnected client callback - Client disconnection');
//     if (client.connectionStatus!.disconnectionOrigin ==
//         MqttDisconnectionOrigin.solicited) {
//       print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
//     } else {
//       print(
//           'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
//       exit(-1);
//     }
//     if (pongCount == 3) {
//       print('EXAMPLE:: Pong count is correct');
//     } else {
//       print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
//     }
//   }

//   /// The successful connect callback
//   void onConnected() {
//     print(
//         'EXAMPLE::OnConnected client callback - Client connection was successful');
//   }

//   /// Pong callback
//   void pong() {
//     print('EXAMPLE::Ping response client callback invoked');
//     pongCount++;
//   }
// }