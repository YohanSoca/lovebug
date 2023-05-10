import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovebug/data/models/lovebug.dart';
import 'package:lovebug/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VentilationScreen extends StatefulWidget {
  const VentilationScreen({super.key});

  @override
  State<VentilationScreen> createState() => _VentilationScreenState();
}

class _VentilationScreenState extends State<VentilationScreen> {
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
        appBar: AppBar(title: const Text("Ventilation", style: TextStyle(fontSize: 22),), actions: [
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
              Card(
                elevation: 16,
                margin: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 62, 61, 57),
                  child: Column(
                    children: [
                                Container(
                                  height: 320,
                                  child: SfRadialGauge(
                                        title: GaugeTitle(
                                            text: 'PORT AFT',
                                            textStyle:
                                                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                        axes: <RadialAxis>[
                                          RadialAxis(minimum: 0, maximum: 50, ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: 10,
                                                color: Colors.green,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 10,
                                                endValue: 30,
                                                color: Colors.orange,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 30,
                                                endValue: 50,
                                                color: Colors.red,
                                                startWidth: 10,
                                                endWidth: 10)
                                          ], pointers: <GaugePointer>[
                                            NeedlePointer(value: lovebug.ventilation.portAft.speed.toDouble() / 29)
                                          ], annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Container(
                                                    child: Text('${lovebug.ventilation.portAft.speed} rpm',
                                                        style: TextStyle(
                                                            fontSize: 25, fontWeight: FontWeight.bold))),
                                                angle: 90,
                                                positionFactor: 0.5)
                                          ])
                                        ]),
                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(20),
                              child: lovebug.ventilation.portAft.direction == 2 ? IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-port-aft-mode-cmd', '2');
                              }, icon: const Icon(Icons.output, size: 45,)) : IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-port-aft-mode-cmd', '1');
                              }, icon: const Icon(Icons.input, size: 45,))
                            ), 
                             Expanded(
                               child: Slider(
                                  value: lovebug.ventilation.portAft.speed.toDouble() / 29,
                                  min: 0,
                                  max: 50,
                                  onChanged: (value) {
                                    setState(() {
                                      mqttClientManager.publishMessage('lovebug-mobile-port-aft-speed-cmd', value.toString());
                                    });
                                  }),
                             ),
                                            ],
                                          ),
                    ],
                  ),
                ),
              Card(
                elevation: 16,
                margin: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 62, 61, 57),
                  child: Column(
                    children: [
                                Container(
                                  height: 320,
                                  child: SfRadialGauge(
                                        title: GaugeTitle(
                                            text: 'PORT FWR',
                                            textStyle:
                                                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                        axes: <RadialAxis>[
                                          RadialAxis(minimum: 0, maximum: 50, ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: 10,
                                                color: Colors.green,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 10,
                                                endValue: 30,
                                                color: Colors.orange,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 30,
                                                endValue: 50,
                                                color: Colors.red,
                                                startWidth: 10,
                                                endWidth: 10)
                                          ], pointers: <GaugePointer>[
                                            NeedlePointer(value: lovebug.ventilation.portFwr.speed.toDouble() / 29)
                                          ], annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Container(
                                                    child: Text('${lovebug.ventilation.portFwr.speed} rpm',
                                                        style: TextStyle(
                                                            fontSize: 25, fontWeight: FontWeight.bold))),
                                                angle: 90,
                                                positionFactor: 0.5)
                                          ])
                                        ]),
                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(20),
                              child: lovebug.ventilation.portFwr.direction == 1 ? IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-port-fwr-mode-cmd', '2');
                              }, icon: const Icon(Icons.input, size: 45,)) : IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-port-fwr-mode-cmd', '1');
                              }, icon: const Icon(Icons.output, size: 45,))
                            ), 
                             Expanded(
                               child: Slider(
                                  value: lovebug.ventilation.portFwr.speed.toDouble() / 29,
                                  min: 0,
                                  max: 50,
                                  onChanged: (value) {
                                    setState(() {
                                      mqttClientManager.publishMessage('lovebug-mobile-port-fwr-speed-cmd', value.toString());
                                    });
                                  }),
                             ),
                                            ],
                                          ),
                    ],
                  ),
                ),
              Card(
                elevation: 16,
                margin: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 62, 61, 57),
                  child: Column(
                    children: [
                                Container(
                                  height: 320,
                                  child: SfRadialGauge(
                                        title: GaugeTitle(
                                            text: 'STBD AFT',
                                            textStyle:
                                                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                        axes: <RadialAxis>[
                                          RadialAxis(minimum: 0, maximum: 50, ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: 10,
                                                color: Colors.green,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 10,
                                                endValue: 30,
                                                color: Colors.orange,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 30,
                                                endValue: 50,
                                                color: Colors.red,
                                                startWidth: 10,
                                                endWidth: 10)
                                          ], pointers: <GaugePointer>[
                                            NeedlePointer(value: lovebug.ventilation.stbdAft.speed.toDouble() / 29)
                                          ], annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Container(
                                                    child: Text('${lovebug.ventilation.stbdAft.speed} rpm',
                                                        style: TextStyle(
                                                            fontSize: 25, fontWeight: FontWeight.bold))),
                                                angle: 90,
                                                positionFactor: 0.5)
                                          ])
                                        ]),
                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(20),
                              child: lovebug.ventilation.stbdAft.direction == 1 ? IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-stbd-aft-mode-cmd', '2');
                              }, icon: const Icon(Icons.input, size: 45,)) : IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-stbd-aft-mode-cmd', '1');
                              }, icon: const Icon(Icons.output, size: 45,))
                            ), 
                             Expanded(
                               child: Slider(
                                  value: lovebug.ventilation.stbdAft.speed.toDouble() / 29,
                                  min: 0,
                                  max: 50,
                                  onChanged: (value) {
                                    setState(() {
                                      mqttClientManager.publishMessage('lovebug-mobile-stbd-aft-speed-cmd', value.toString());
                                    });
                                  }),
                             ),
                                            ],
                                          ),
                    ],
                  ),
                ),
                Card(
                elevation: 16,
                margin: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 62, 61, 57),
                  child: Column(
                    children: [
                                Container(
                                  height: 320,
                                  child: SfRadialGauge(
                                        title: GaugeTitle(
                                            text: 'STBD FWR',
                                            textStyle:
                                                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                        axes: <RadialAxis>[
                                          RadialAxis(minimum: 0, maximum: 50, ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: 10,
                                                color: Colors.green,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 10,
                                                endValue: 30,
                                                color: Colors.orange,
                                                startWidth: 10,
                                                endWidth: 10),
                                            GaugeRange(
                                                startValue: 30,
                                                endValue: 50,
                                                color: Colors.red,
                                                startWidth: 10,
                                                endWidth: 10)
                                          ], pointers: <GaugePointer>[
                                            NeedlePointer(value: lovebug.ventilation.stbdFwr.speed.toDouble() / 29)
                                          ], annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Container(
                                                    child: Text('${lovebug.ventilation.stbdFwr.speed} rpm',
                                                        style: TextStyle(
                                                            fontSize: 25, fontWeight: FontWeight.bold))),
                                                angle: 90,
                                                positionFactor: 0.5)
                                          ])
                                        ]),
                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(20),
                              child: lovebug.ventilation.stbdFwr.direction == 1 ? IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-stbd-fwr-mode-cmd', '2');
                              }, icon: const Icon(Icons.input, size: 45,)) : IconButton(onPressed: () {
                                mqttClientManager.publishMessage('lovebug-mobile-stbd-fwr-mode-cmd', '1');
                              }, icon: const Icon(Icons.output, size: 45,))
                            ), 
                             Expanded(
                               child: Slider(
                                  value: lovebug.ventilation.stbdFwr.speed.toDouble() / 29,
                                  min: 0,
                                  max: 50,
                                  onChanged: (value) {
                                    setState(() {
                                      mqttClientManager.publishMessage('lovebug-mobile-stbd-fwr-speed-cmd', value.toString());
                                    });
                                  }),
                             ),
                                            ],
                                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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