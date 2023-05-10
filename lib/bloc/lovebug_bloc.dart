import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/lovebug.dart';

part 'lovebug_event.dart';
part 'lovebug_state.dart';

var initialState = {
    "asea": {
        "data" : {}
    },
    "shore": {
        "online": false,
        "in-progress": false,
        "data": [0, 0, 0, 0],
        "alarms": ["none"],
        "status": {
            "word-one": 0,
            "word-two": 0,
            "word-three": 0
        }
    },
    "converter": {
        "data": [0, 0, 0, 0],
        "in-progress": false,
        "alarms": ["none"]
    },
    "port": {
        "online": false,
        "in-progress": false,
        "data": [0, 0, 0, 0],
        "alarms": ["none"]
    },
        "stbd": {
        "online": false,
        "in-progress": false,
        "data": [0, 0, 0, 0],
        "alarms": ["none"]
    },
    "modes": {
        "split-bus": false,
        "auto-mode": true
    },
        "serial": {
        "connected": false,
        "errors": false
    },
    "control-register": {
        "transfer-to-shore": false,
        "transfer-to-port": false,
        "transfer-to-stbd": false,
        "tie-breakder": false,
        "blackout": false,
        "feedback": [],
        "coils": []
    },
    "ventilation": {
        "port-aft": 
            {"direction": 0, "speed": 0, "on": false},
        "port-fwr":
            {"direction": 0, "speed": 0, "on": false},
        "stbd-aft":
            {"direction": 0, "speed": 0, "on": false},
        "stbd-fwr":
            {"direction": 0, "speed": 0, "on": false}
    },
    "bilges": {
        "data": []
    },
    "tanks": {
        "water": 0,
        "black-water": 0,
        "main-fuel-one": 0,
        "main-fuel-two": 0,
        "daily": 0
    },
    "thruster": {
        "auto": false,
        "on": false
    }
};

class LovebugBloc extends Bloc<LovebugEvent, Lovebug> {
  LovebugBloc() : super(Lovebug.fromJson(json.decode(initialState.toString()))) {
    on<LovebugEvent>((event, emit) {
      // TODO: implement event handler
      
    });
  }
}
