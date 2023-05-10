// To parse this JSON data, do
//
//     final lovebug = lovebugFromJson(jsonString);

import 'dart:convert';

Lovebug lovebugFromJson(String str) => Lovebug.fromJson(json.decode(str));

String lovebugToJson(Lovebug data) => json.encode(data.toJson());

class Lovebug {
    Asea asea;
    Converter shore;
    Converter converter;
    Converter port;
    Converter stbd;
    Modes modes;
    Serial serial;
    ControlRegister controlRegister;
    Ventilation ventilation;
    Bilges bilges;
    Tanks tanks;
    Thruster thruster;

    Lovebug({
        required this.asea,
        required this.shore,
        required this.converter,
        required this.port,
        required this.stbd,
        required this.modes,
        required this.serial,
        required this.controlRegister,
        required this.ventilation,
        required this.bilges,
        required this.tanks,
        required this.thruster,
    });

    factory Lovebug.fromJson(Map<String, dynamic> json) => Lovebug(
        asea: Asea.fromJson(json["asea"]),
        shore: Converter.fromJson(json["shore"]),
        converter: Converter.fromJson(json["converter"]),
        port: Converter.fromJson(json["port"]),
        stbd: Converter.fromJson(json["stbd"]),
        modes: Modes.fromJson(json["modes"]),
        serial: Serial.fromJson(json["serial"]),
        controlRegister: ControlRegister.fromJson(json["control-register"]),
        ventilation: Ventilation.fromJson(json["ventilation"]),
        bilges: Bilges.fromJson(json["bilges"]),
        tanks: Tanks.fromJson(json["tanks"]),
        thruster: Thruster.fromJson(json["thruster"]),
    );

    Map<String, dynamic> toJson() => {
        "asea": asea.toJson(),
        "shore": shore.toJson(),
        "converter": converter.toJson(),
        "port": port.toJson(),
        "stbd": stbd.toJson(),
        "modes": modes.toJson(),
        "serial": serial.toJson(),
        "control-register": controlRegister.toJson(),
        "ventilation": ventilation.toJson(),
        "bilges": bilges.toJson(),
        "tanks": tanks.toJson(),
        "thruster": thruster.toJson(),
    };
}

class Asea {
    Data data;

    Asea({
        required this.data,
    });

    factory Asea.fromJson(Map<String, dynamic> json) => Asea(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    int wordOne;
    int wordTwo;
    int wordThree;

    Data({
        required this.wordOne,
        required this.wordTwo,
        required this.wordThree,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        wordOne: json["word-one"],
        wordTwo: json["word-two"],
        wordThree: json["word-three"],
    );

    Map<String, dynamic> toJson() => {
        "word-one": wordOne,
        "word-two": wordTwo,
        "word-three": wordThree,
    };
}

class Bilges {
    List<dynamic> data;

    Bilges({
        required this.data,
    });

    factory Bilges.fromJson(Map<String, dynamic> json) => Bilges(
        data: List<dynamic>.from(json["data"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
    };
}

class ControlRegister {
    bool transferToShore;
    bool transferToPort;
    bool transferToStbd;
    bool tieBreakder;
    bool blackout;
    List<dynamic> feedback;
    List<dynamic> coils;

    ControlRegister({
        required this.transferToShore,
        required this.transferToPort,
        required this.transferToStbd,
        required this.tieBreakder,
        required this.blackout,
        required this.feedback,
        required this.coils,
    });

    factory ControlRegister.fromJson(Map<String, dynamic> json) => ControlRegister(
        transferToShore: json["transfer-to-shore"],
        transferToPort: json["transfer-to-port"],
        transferToStbd: json["transfer-to-stbd"],
        tieBreakder: json["tie-breakder"],
        blackout: json["blackout"],
        feedback: List<dynamic>.from(json["feedback"].map((x) => x)),
        coils: List<dynamic>.from(json["coils"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "transfer-to-shore": transferToShore,
        "transfer-to-port": transferToPort,
        "transfer-to-stbd": transferToStbd,
        "tie-breakder": tieBreakder,
        "blackout": blackout,
        "feedback": List<dynamic>.from(feedback.map((x) => x)),
        "coils": List<dynamic>.from(coils.map((x) => x)),
    };
}

class Converter {
    List<int> data;
    bool inProgress;
    List<String> alarms;
    bool? online;
    Data? status;

    Converter({
        required this.data,
        required this.inProgress,
        required this.alarms,
        this.online,
        this.status,
    });

    factory Converter.fromJson(Map<String, dynamic> json) => Converter(
        data: List<int>.from(json["data"].map((x) => x)),
        inProgress: json["in-progress"],
        alarms: List<String>.from(json["alarms"].map((x) => x)),
        online: json["online"],
        status: json["status"] == null ? null : Data.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
        "in-progress": inProgress,
        "alarms": List<dynamic>.from(alarms.map((x) => x)),
        "online": online,
        "status": status?.toJson(),
    };
}

class Modes {
    bool splitBus;
    bool autoMode;

    Modes({
        required this.splitBus,
        required this.autoMode,
    });

    factory Modes.fromJson(Map<String, dynamic> json) => Modes(
        splitBus: json["split-bus"],
        autoMode: json["auto-mode"],
    );

    Map<String, dynamic> toJson() => {
        "split-bus": splitBus,
        "auto-mode": autoMode,
    };
}

class Serial {
    bool connected;
    bool errors;

    Serial({
        required this.connected,
        required this.errors,
    });

    factory Serial.fromJson(Map<String, dynamic> json) => Serial(
        connected: json["connected"],
        errors: json["errors"],
    );

    Map<String, dynamic> toJson() => {
        "connected": connected,
        "errors": errors,
    };
}

class Tanks {
    int water;
    int blackWater;
    int mainFuelOne;
    int mainFuelTwo;
    int daily;

    Tanks({
        required this.water,
        required this.blackWater,
        required this.mainFuelOne,
        required this.mainFuelTwo,
        required this.daily,
    });

    factory Tanks.fromJson(Map<String, dynamic> json) => Tanks(
        water: json["water"],
        blackWater: json["black-water"],
        mainFuelOne: json["main-fuel-one"],
        mainFuelTwo: json["main-fuel-two"],
        daily: json["daily"],
    );

    Map<String, dynamic> toJson() => {
        "water": water,
        "black-water": blackWater,
        "main-fuel-one": mainFuelOne,
        "main-fuel-two": mainFuelTwo,
        "daily": daily,
    };
}

class Thruster {
    bool auto;
    bool on;

    Thruster({
        required this.auto,
        required this.on,
    });

    factory Thruster.fromJson(Map<String, dynamic> json) => Thruster(
        auto: json["auto"],
        on: json["on"],
    );

    Map<String, dynamic> toJson() => {
        "auto": auto,
        "on": on,
    };
}

class Ventilation {
    PortAft portAft;
    PortAft portFwr;
    PortAft stbdAft;
    PortAft stbdFwr;

    Ventilation({
        required this.portAft,
        required this.portFwr,
        required this.stbdAft,
        required this.stbdFwr,
    });

    factory Ventilation.fromJson(Map<String, dynamic> json) => Ventilation(
        portAft: PortAft.fromJson(json["port-aft"]),
        portFwr: PortAft.fromJson(json["port-fwr"]),
        stbdAft: PortAft.fromJson(json["stbd-aft"]),
        stbdFwr: PortAft.fromJson(json["stbd-fwr"]),
    );

    Map<String, dynamic> toJson() => {
        "port-aft": portAft.toJson(),
        "port-fwr": portFwr.toJson(),
        "stbd-aft": stbdAft.toJson(),
        "stbd-fwr": stbdFwr.toJson(),
    };
}

class PortAft {
    int direction;
    int speed;
    bool on;

    PortAft({
        required this.direction,
        required this.speed,
        required this.on,
    });

    factory PortAft.fromJson(Map<String, dynamic> json) => PortAft(
        direction: json["direction"],
        speed: json["speed"],
        on: json["on"],
    );

    Map<String, dynamic> toJson() => {
        "direction": direction,
        "speed": speed,
        "on": on,
    };
}
