import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TanksScreen extends StatefulWidget {
  const TanksScreen({super.key});

  @override
  State<TanksScreen> createState() => _TanksScreenState();
}

class _TanksScreenState extends State<TanksScreen> {
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
        appBar: AppBar(title: const Text("Tanks", style: TextStyle(fontSize: 22),), actions: [
          connected ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Connected", style: TextStyle(color: Colors.green, fontSize: 18),),
          ) : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Disconnected", style: TextStyle(color: Colors.red, fontSize: 16),),
          )
        ],),
        body: connected ? SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity / 2,
                  child: Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        Text('Fresh Water', style: TextStyle(fontSize: 26),),
                        Container(
                      margin: EdgeInsets.all(16),
                      height: 200,
                      width: 200,
                      child: LiquidCircularProgressIndicator(
                        value: lovebug.tanks.water / 2500, // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.blue,
                        borderWidth: 5.0,
                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text('${lovebug.tanks.water} Lts', style: TextStyle(fontSize: 26, color: Colors.black),),
                      ),
                    ),  
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity / 2,
                  child: Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        Text('Daily', style: TextStyle(fontSize: 26),),
                        Container(
                      margin: EdgeInsets.all(16),
                      height: 200,
                      width: 200,
                      child: LiquidCircularProgressIndicator(
                        value: lovebug.tanks.daily / 4000, // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.amberAccent,
                        borderWidth: 5.0,
                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text('${lovebug.tanks.daily} Lts', style: TextStyle(fontSize: 26, color: Colors.black),),
                      ),
                    ),  
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity / 2,
                  child: Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        Text('Main Fuel 1', style: TextStyle(fontSize: 26),),
                        Container(
                      margin: EdgeInsets.all(16),
                      height: 200,
                      width: 200,
                      child: LiquidCircularProgressIndicator(
                        value: lovebug.tanks.mainFuelOne / 6000, // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.amber,
                        borderWidth: 5.0,
                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text('${lovebug.tanks.mainFuelOne} Lts', style: TextStyle(fontSize: 26, color: Colors.black),),
                      ),
                    ),  
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity / 2,
                  child: Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        Text('Main Fuel 2', style: TextStyle(fontSize: 26),),
                        Container(
                      margin: EdgeInsets.all(16),
                      height: 200,
                      width: 200,
                      child: LiquidCircularProgressIndicator(
                        value: lovebug.tanks.mainFuelTwo / 6000, // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.amber,
                        borderWidth: 5.0,
                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text('${lovebug.tanks.mainFuelTwo} Lts', style: TextStyle(fontSize: 26, color: Colors.black),),
                      ),
                    ),  
                      ],
                    ),
                  ),
                ),
                
                ],
            ),
          )
          )
      : Center(child: CircularProgressIndicator(color: Colors.blueAccent))
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