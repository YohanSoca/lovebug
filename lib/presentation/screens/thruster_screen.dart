import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ThrusterScreen extends StatefulWidget {
  const ThrusterScreen({super.key});

  @override
  State<ThrusterScreen> createState() => _ThrusterScreenState();
}

class _ThrusterScreenState extends State<ThrusterScreen> {
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
        appBar: AppBar(title: const Text("Thruster", style: TextStyle(fontSize: 22),), actions: [
          connected ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Connected", style: TextStyle(color: Colors.green, fontSize: 18),),
          ) : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Disconnected", style: TextStyle(color: Colors.red, fontSize: 16),),
          )
        ],),
        body: connected ? SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container( // port gen
                                    margin: EdgeInsets.only(right: 20),
                                      width: 165,
                                     height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                              BoxShadow(
                                color: lovebug.port.data[0] > 100 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                                        color: Color.fromARGB(255, 62, 61, 57)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text("PORT ${lovebug.controlRegister.feedback[0] ? 'ONLINE' : 'OFFLINE'}", style: TextStyle(fontSize: 20),),
                                              Text("${lovebug.port.data[18] / 10} KW", style: TextStyle(fontSize: 20),),
                                            ],
                                          )
                                        ),
                                        ),
                                    Container(width: 20, height: 100, decoration: BoxDecoration(
                                        color: lovebug.controlRegister.feedback[0] ? Colors.green : Colors.grey),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 165,
                                     height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                              BoxShadow(
                                color: lovebug.stbd.data[0] > 100 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                                        color: Color.fromARGB(255, 62, 61, 57)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text("STBS ${lovebug.controlRegister.feedback[1] ? 'ONLINE' : 'OFFLINE'}", style: TextStyle(fontSize: 20),),
                                              Text("${lovebug.stbd.data[18] / 10} KW", style: TextStyle(fontSize: 20),),
                                            ],
                                          )
                                        ),
                                        ),
                                    Container(width: 20, height: 100, decoration: BoxDecoration(
                                        color: lovebug.controlRegister.feedback[1] ? Colors.green : Colors.grey),)
                                  ],
                                )
                              ],
                            ),
                            Row( //main bus bar
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(width: 250, height: 20, decoration: BoxDecoration(
                                        color: (lovebug.controlRegister.feedback[0] || lovebug.controlRegister.feedback[1]) ?
                                         Colors.green : Colors.grey),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            Row( //  thruster feeder
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(width: 20, height: 100, decoration: BoxDecoration(
                                        color: (lovebug.controlRegister.feedback[0] || lovebug.controlRegister.feedback[1]) ?
                                         Colors.green : Colors.green),),
                                  ],
                                )
                              ],
                            ),
                            Row( // thruster
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onDoubleTap: () {
                                        if(lovebug.thruster.auto) {
                                          mqttClientManager.publishMessage('lovebug-mobile-thruster-mode-cmd', 'false');
                                        } else {
                                          mqttClientManager.publishMessage('lovebug-mobile-thruster-mode-cmd', 'true');
                                        }
                                      },
                                      child: Container(
                                        width: 200,
                                       height: 100,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                              BoxShadow(
                                color: lovebug.thruster.on ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                                          color: Color.fromARGB(255, 62, 61, 57)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("THRUSTER: ${lovebug.thruster.on ? 'ON' : 'OFF'}", style: TextStyle(fontSize: 20)),
                                              Text("MODE: ${lovebug.thruster.auto  ? 'AUTO' : 'MANUAL'}", style: TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                       )       
            ],
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