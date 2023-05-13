import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BilgesScreen extends StatefulWidget {
  const BilgesScreen({super.key});

  @override
  State<BilgesScreen> createState() => _BilgesScreenState();
}

class _BilgesScreenState extends State<BilgesScreen> {
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "lovebug";
  late Lovebug lovebug;
  late Timer timer;
  int _portAft = 0;

  bool connected = false;


   @override
  void initState() {
    super.initState();
    setupMqttClient();
    setupUpdatesListener();
    Timer.periodic(const Duration(seconds: 6), (timer) {
        if (mqttClientManager.client.connectionStatus!.state ==
            MqttConnectionState.connecting) {
                setState(() {
                  connected = false;
                });
            }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Bilges", style: TextStyle(fontSize: 22),), actions: [
          connected ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Connected", style: TextStyle(color: Colors.green, fontSize: 18),),
          ) : const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Disconnected", style: TextStyle(color: Colors.red, fontSize: 16),),
          )
        ],),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("${lovebug.asea.data.wordOne}"),
              Text("${lovebug.asea.data.wordTwo}"),
              Text("${lovebug.asea.data.wordThree}"),
              ElevatedButton(onPressed: () {
                setState(() {
                  mqttClientManager.disconnect();
                  connected = false;
                });
              }, child: Text("disconnect")),
              ElevatedButton(onPressed: () {
               setState(() {
                      mqttClientManager.client.server = "24.199.84.80";
                      mqttClientManager.client.port = 1883;
                     setupMqttClient();
                     setupUpdatesListener();
                     print("${mqttClientManager.client.server}:${mqttClientManager.client.port}");
               });
              }, child: Text("connect")),
             connected ? Text("${lovebug.port.data[0]}") : Text("0")
            ],
          )
        )
        );
  }
   
    Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(pubTopic);

  }

  void _publishToBroker(String topic, String value) {
    setState(() {
      mqttClientManager.publishMessage(topic, value);
    });
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
        if (mqttClientManager.client.connectionStatus!.state ==
            MqttConnectionState.connected) {
           if(c[0].topic == 'lovebug') {
              setState(() {
                print(lovebug.toString());
                connected = true;
                lovebug = Lovebug.fromJson(json.decode(pt as String));
              });
          }
        }
      });
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }
}