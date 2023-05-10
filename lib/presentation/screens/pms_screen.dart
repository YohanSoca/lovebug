import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PMSScreen extends StatefulWidget {
  const PMSScreen({super.key});

  @override
  State<PMSScreen> createState() => _PMSScreenState();
}

class _PMSScreenState extends State<PMSScreen> {
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "lovebug";
  late Lovebug lovebug;
  late Timer timer;
  int _portAft = 0;
  bool lineToLine = false;

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
        appBar: AppBar(title: const Text("PMS", style: TextStyle(fontSize: 22),), actions: [
          connected ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Connected", style: TextStyle(color: Colors.green, fontSize: 18),),
          ) : const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Disconnected", style: TextStyle(color: Colors.red, fontSize: 16),),
          )
        ],),
        body: connected ? SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onDoubleTap: () => setState(() {
                          lineToLine = !lineToLine;
                        }),
                        child: Container(
                          margin: EdgeInsets.only(left: 10, top: 20),
                          padding: EdgeInsets.all(16),
                          height: 140,
                          width: 190,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 62, 61, 57),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: lovebug.converter.data[0] > 100 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                            ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text("Shore", style: TextStyle(fontSize: 22),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('${lovebug.converter.data[0]}V', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.converter.data[1]}V', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.converter.data[2]}V', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  ],
                              ),
                              Row(  
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${lovebug.converter.data[3]}A', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.converter.data[4]}A', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.converter.data[5]}A', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('${lovebug.converter.data[6]} Hz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                      Container( /// shore power feeder
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(color: lovebug.converter.data[0] > 100 ? Colors.green : Colors.grey),
                      ), 
                      Transform.rotate(
                            angle: lovebug.controlRegister.feedback[2] ? 0 : 45,
                            child: Container(
                              color: lovebug.controlRegister.feedback[2]? Colors.green : Colors.grey,
                              width: 40,
                              height: 20,
                            ),
                          ),
                      Container( // Shore main drop
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(
                          color: lovebug.controlRegister.feedback[0] ||
                       lovebug.controlRegister.feedback[1] ||
                       lovebug.controlRegister.feedback[2] ?
                       Colors.green : Colors.grey),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onDoubleTap: () => setState(() {
                          lineToLine = !lineToLine;
                          print(lineToLine);
                        }),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 20),
                          padding: const EdgeInsets.all(16),
                          height: 140,
                          width: 190,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 62, 61, 57),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: lovebug.port.data[0] > 100 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                             ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text("PORT", style: TextStyle(fontSize: 22),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('${lovebug.port.data[(lineToLine ? 0 : 3)]}V',
                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.port.data[(lineToLine ? 1 : 4)]}V',
                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.port.data[(lineToLine ? 2 : 5)]}V',
                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${lovebug.port.data[6]}A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.port.data[7]}A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.port.data[8]}A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('${(lovebug.port.data[20] / 100).toInt()}Hz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                      Container( /// shore power feeder
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          color: lovebug.port.data[0] > 100 ? Colors.green : Colors.grey
                          ),
                      ), 
                      Transform.rotate(
                            angle: lovebug.controlRegister.feedback[0] ? 0 : 45,
                            child: Container(
                              color: lovebug.controlRegister.feedback[0]? Colors.green : Colors.grey,
                              width: 40,
                              height: 20,
                            ),
                          ), 
                      Container(
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(color: lovebug.controlRegister.feedback[0] ||
                       lovebug.controlRegister.feedback[1] ||
                       lovebug.controlRegister.feedback[2] ?
                       Colors.green : Colors.grey),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onDoubleTap: () => setState(() {
                          lineToLine = !lineToLine;
                        }),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 20),
                          padding: const EdgeInsets.all(16),
                          height: 140,
                          width: 190,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 62, 61, 57),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: lovebug.stbd.data[0] > 100 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                             ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text("STBD", style: TextStyle(fontSize: 22),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('${lovebug.stbd.data[(lineToLine ? 0 : 3)]}V', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.stbd.data[(lineToLine ? 1 : 4)]}V', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Text('${lovebug.stbd.data[(lineToLine ? 2 : 5)]}V', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${lovebug.stbd.data[4]} A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.stbd.data[5]} A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Text('${lovebug.stbd.data[6]} A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('${lovebug.stbd.data[20]} Hz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                      Container( /// shore power feeder
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          color: lovebug.stbd.data[0] > 100 ? Colors.green : Colors.grey
                          ),
                      ), 
                      Transform.rotate(
                            angle: lovebug.controlRegister.feedback[1] ? 0 : 45,
                            child: Container(
                              color: lovebug.controlRegister.feedback[1]? Colors.green : Colors.grey,
                              width: 40,
                              height: 20,
                            ),
                          ), 
                      Container(
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(color: lovebug.controlRegister.feedback[0] ||
                       lovebug.controlRegister.feedback[1] ||
                       lovebug.controlRegister.feedback[2] ?
                       Colors.green : Colors.grey),
                      )
                    ],
                  ),
                ),
                
                ],
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 20,
                  height: 600,
                  decoration: BoxDecoration(
                    color: lovebug.controlRegister.feedback[0] ||
                     lovebug.controlRegister.feedback[1] ||
                     lovebug.controlRegister.feedback[2] ?
                     Colors.green : Colors.grey
                    ),
                )
              ],
            )
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