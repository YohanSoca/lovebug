import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ShoreScreen extends StatefulWidget {
  const ShoreScreen({super.key});

  @override
  State<ShoreScreen> createState() => _ShoreScreenState();
}

class _ShoreScreenState extends State<ShoreScreen> {
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
        appBar: AppBar(title: const Text("Shore Power", style: TextStyle(fontSize: 22),), actions: [
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
                padding: EdgeInsets.all(8),
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[0]} V", style: TextStyle(fontSize: 30),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[1]} V", style: TextStyle(fontSize: 30),),
                          ),
                          Text("${lovebug.shore.data[2]} V", style: TextStyle(fontSize: 30),)
                        ],
                      ),
                      Divider(thickness: 3, color: Colors.amber,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[3]} A", style: TextStyle(fontSize: 30),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[4]} A", style: TextStyle(fontSize: 30),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[5]} A", style: TextStyle(fontSize: 30),),
                          )
                        ],
                      ),
                      Divider(thickness: 3, color: Colors.amber,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${lovebug.shore.data[6]} Hz", style: TextStyle(fontSize: 30),),
                          ),
                        ],
                      ),
                      Divider(thickness: 3, color: Colors.amber,),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.green, fixedSize: Size(130, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-shore-on-cmd', 'true');
                          }, child: Text('ON', style: TextStyle(fontSize: 20),)),
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.red, fixedSize: Size(130, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-shore-off-cmd', 'true');
                          }, child: Text('OFF', style: TextStyle(fontSize: 20))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.green, fixedSize: Size(130, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-converter-on-cmd', 'true');
                          }, child: Text('CONV-ON', style: TextStyle(fontSize: 20))),
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.red, fixedSize: Size(130, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-converter-off-cmd', 'true');
                          }, child: Text('CONV-OFF', style: TextStyle(fontSize: 20))),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(16),
                            child: Text("Transfers", style: TextStyle(fontSize: 22),),
                            ),
                            Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.green, fixedSize: Size(95, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-transfer-to-port-cmd', 'true');
                          }, child: Text('PORT', style: TextStyle(fontSize: 18))),
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.green, fixedSize: Size(95, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-transfer-to-stbd-cmd', 'true');
                          }, child: Text('STBD', style: TextStyle(fontSize: 18))),
                          ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.green, fixedSize: Size(95, 30)),
                            onPressed: () {
                            mqttClientManager.publishMessage('lovebug-mobile-transfer-to-shore-cmd', 'true');
                          }, child: Text('SHORE', style: TextStyle(fontSize: 18))),
                        ],
                      )
                    
                          ],
                        ),
                      )
                          ],
                        ),
                      )
                      ],
                  ),
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