// To parse this JSON data, do
//
//     final asea = aseaFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Asea {
    String serialCmd;
    int date;
    bool blinking;
    bool firstCycle;
    String errors;
    bool overTemperature;
    String name;
    Serial serial;
    Converter shore;
    Converter converter;
    Port port;
    Port stbd;
    StatusWords statusWords;
    Pms pms;

    Asea({
        required this.serialCmd,
        required this.date,
        required this.blinking,
        required this.firstCycle,
        required this.errors,
        required this.overTemperature,
        required this.name,
        required this.serial,
        required this.shore,
        required this.converter,
        required this.port,
        required this.stbd,
        required this.statusWords,
        required this.pms,
    });

    Asea copyWith({
        String? serialCmd,
        int? date,
        bool? blinking,
        bool? firstCycle,
        String? errors,
        bool? overTemperature,
        String? name,
        Serial? serial,
        Converter? shore,
        Converter? converter,
        Port? port,
        Port? stbd,
        StatusWords? statusWords,
        Pms? pms,
    }) =>
        Asea(
            serialCmd: serialCmd ?? this.serialCmd,
            date: date ?? this.date,
            blinking: blinking ?? this.blinking,
            firstCycle: firstCycle ?? this.firstCycle,
            errors: errors ?? this.errors,
            overTemperature: overTemperature ?? this.overTemperature,
            name: name ?? this.name,
            serial: serial ?? this.serial,
            shore: shore ?? this.shore,
            converter: converter ?? this.converter,
            port: port ?? this.port,
            stbd: stbd ?? this.stbd,
            statusWords: statusWords ?? this.statusWords,
            pms: pms ?? this.pms,
        );

    factory Asea.fromRawJson(String str) => Asea.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Asea.fromJson(Map<String, dynamic> json) => Asea(
        serialCmd: json["serial_cmd"],
        date: json["date"],
        blinking: json["blinking"],
        firstCycle: json["first_cycle"],
        errors: json["errors"],
        overTemperature: json["over_temperature"],
        name: json["name"],
        serial: Serial.fromJson(json["serial"]),
        shore: Converter.fromJson(json["shore"]),
        converter: Converter.fromJson(json["converter"]),
        port: Port.fromJson(json["port"]),
        stbd: Port.fromJson(json["stbd"]),
        statusWords: StatusWords.fromJson(json["status_words"]),
        pms: Pms.fromJson(json["pms"]),
    );

    Map<String, dynamic> toJson() => {
        "serial_cmd": serialCmd,
        "date": date,
        "blinking": blinking,
        "first_cycle": firstCycle,
        "errors": errors,
        "over_temperature": overTemperature,
        "name": name,
        "serial": serial.toJson(),
        "shore": shore.toJson(),
        "converter": converter.toJson(),
        "port": port.toJson(),
        "stbd": stbd.toJson(),
        "status_words": statusWords.toJson(),
        "pms": pms.toJson(),
    };
}

class Converter {
    List<dynamic> meters;
    ConverterStatus status;

    Converter({
        required this.meters,
        required this.status,
    });

    Converter copyWith({
        List<dynamic>? meters,
        ConverterStatus? status,
    }) =>
        Converter(
            meters: meters ?? this.meters,
            status: status ?? this.status,
        );

    factory Converter.fromRawJson(String str) => Converter.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Converter.fromJson(Map<String, dynamic> json) => Converter(
        meters: List<dynamic>.from(json["meters"].map((x) => x)),
        status: ConverterStatus.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "meters": List<dynamic>.from(meters.map((x) => x)),
        "status": status.toJson(),
    };
}

class ConverterStatus {
    bool online;
    bool on;

    ConverterStatus({
        required this.online,
        required this.on,
    });

    ConverterStatus copyWith({
        bool? online,
        bool? on,
    }) =>
        ConverterStatus(
            online: online ?? this.online,
            on: on ?? this.on,
        );

    factory ConverterStatus.fromRawJson(String str) => ConverterStatus.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConverterStatus.fromJson(Map<String, dynamic> json) => ConverterStatus(
        online: json["online"],
        on: json["on"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "on": on,
    };
}

class Pms {
    bool setPortAsMasterRequested;
    bool setStbdAsMasterRequested;
    bool turnOnShorePowerRequested;
    bool turnOffShorePowerRequested;
    bool turnOnConverterRequested;
    bool turnOffConverterRequested;
    String lastTransferStatus;
    bool transferInProgress;
    bool transferToGenRequested;
    bool transferToConverterRequested;
    String requestResponse;

    Pms({
        required this.setPortAsMasterRequested,
        required this.setStbdAsMasterRequested,
        required this.turnOnShorePowerRequested,
        required this.turnOffShorePowerRequested,
        required this.turnOnConverterRequested,
        required this.turnOffConverterRequested,
        required this.lastTransferStatus,
        required this.transferInProgress,
        required this.transferToGenRequested,
        required this.transferToConverterRequested,
        required this.requestResponse,
    });

    Pms copyWith({
        bool? setPortAsMasterRequested,
        bool? setStbdAsMasterRequested,
        bool? turnOnShorePowerRequested,
        bool? turnOffShorePowerRequested,
        bool? turnOnConverterRequested,
        bool? turnOffConverterRequested,
        String? lastTransferStatus,
        bool? transferInProgress,
        bool? transferToGenRequested,
        bool? transferToConverterRequested,
        String? requestResponse,
    }) =>
        Pms(
            setPortAsMasterRequested: setPortAsMasterRequested ?? this.setPortAsMasterRequested,
            setStbdAsMasterRequested: setStbdAsMasterRequested ?? this.setStbdAsMasterRequested,
            turnOnShorePowerRequested: turnOnShorePowerRequested ?? this.turnOnShorePowerRequested,
            turnOffShorePowerRequested: turnOffShorePowerRequested ?? this.turnOffShorePowerRequested,
            turnOnConverterRequested: turnOnConverterRequested ?? this.turnOnConverterRequested,
            turnOffConverterRequested: turnOffConverterRequested ?? this.turnOffConverterRequested,
            lastTransferStatus: lastTransferStatus ?? this.lastTransferStatus,
            transferInProgress: transferInProgress ?? this.transferInProgress,
            transferToGenRequested: transferToGenRequested ?? this.transferToGenRequested,
            transferToConverterRequested: transferToConverterRequested ?? this.transferToConverterRequested,
            requestResponse: requestResponse ?? this.requestResponse,
        );

    factory Pms.fromRawJson(String str) => Pms.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pms.fromJson(Map<String, dynamic> json) => Pms(
        setPortAsMasterRequested: json["set_port_as_master_requested"],
        setStbdAsMasterRequested: json["set_stbd_as_master_requested"],
        turnOnShorePowerRequested: json["turn_on_shore_power_requested"],
        turnOffShorePowerRequested: json["turn_off_shore_power_requested"],
        turnOnConverterRequested: json["turn_on_converter_requested"],
        turnOffConverterRequested: json["turn_off_converter_requested"],
        lastTransferStatus: json["last_transfer_status"],
        transferInProgress: json["transfer_in_progress"],
        transferToGenRequested: json["transfer_to_gen_requested"],
        transferToConverterRequested: json["transfer_to_converter_requested"],
        requestResponse: json["request_response"],
    );

    Map<String, dynamic> toJson() => {
        "set_port_as_master_requested": setPortAsMasterRequested,
        "set_stbd_as_master_requested": setStbdAsMasterRequested,
        "turn_on_shore_power_requested": turnOnShorePowerRequested,
        "turn_off_shore_power_requested": turnOffShorePowerRequested,
        "turn_on_converter_requested": turnOnConverterRequested,
        "turn_off_converter_requested": turnOffConverterRequested,
        "last_transfer_status": lastTransferStatus,
        "transfer_in_progress": transferInProgress,
        "transfer_to_gen_requested": transferToGenRequested,
        "transfer_to_converter_requested": transferToConverterRequested,
        "request_response": requestResponse,
    };
}

class Port {
    List<dynamic> meters;
    PortStatus status;

    Port({
        required this.meters,
        required this.status,
    });

    Port copyWith({
        List<dynamic>? meters,
        PortStatus? status,
    }) =>
        Port(
            meters: meters ?? this.meters,
            status: status ?? this.status,
        );

    factory Port.fromRawJson(String str) => Port.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Port.fromJson(Map<String, dynamic> json) => Port(
        meters: List<dynamic>.from(json["meters"].map((x) => x)),
        status: PortStatus.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "meters": List<dynamic>.from(meters.map((x) => x)),
        "status": status.toJson(),
    };
}

class PortStatus {
    bool online;
    bool master;

    PortStatus({
        required this.online,
        required this.master,
    });

    PortStatus copyWith({
        bool? online,
        bool? master,
    }) =>
        PortStatus(
            online: online ?? this.online,
            master: master ?? this.master,
        );

    factory PortStatus.fromRawJson(String str) => PortStatus.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PortStatus.fromJson(Map<String, dynamic> json) => PortStatus(
        online: json["online"],
        master: json["master"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "master": master,
    };
}

class Serial {
    SerialStatus status;

    Serial({
        required this.status,
    });

    Serial copyWith({
        SerialStatus? status,
    }) =>
        Serial(
            status: status ?? this.status,
        );

    factory Serial.fromRawJson(String str) => Serial.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Serial.fromJson(Map<String, dynamic> json) => Serial(
        status: SerialStatus.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status.toJson(),
    };
}

class SerialStatus {
    String fill;
    String shape;
    String text;
    Source source;

    SerialStatus({
        required this.fill,
        required this.shape,
        required this.text,
        required this.source,
    });

    SerialStatus copyWith({
        String? fill,
        String? shape,
        String? text,
        Source? source,
    }) =>
        SerialStatus(
            fill: fill ?? this.fill,
            shape: shape ?? this.shape,
            text: text ?? this.text,
            source: source ?? this.source,
        );

    factory SerialStatus.fromRawJson(String str) => SerialStatus.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SerialStatus.fromJson(Map<String, dynamic> json) => SerialStatus(
        fill: json["fill"],
        shape: json["shape"],
        text: json["text"],
        source: Source.fromJson(json["source"]),
    );

    Map<String, dynamic> toJson() => {
        "fill": fill,
        "shape": shape,
        "text": text,
        "source": source.toJson(),
    };
}

class Source {
    String id;
    String type;
    String name;

    Source({
        required this.id,
        required this.type,
        required this.name,
    });

    Source copyWith({
        String? id,
        String? type,
        String? name,
    }) =>
        Source(
            id: id ?? this.id,
            type: type ?? this.type,
            name: name ?? this.name,
        );

    factory Source.fromRawJson(String str) => Source.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        type: json["type"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
    };
}

class StatusWords {
    String wordZero;
    String wordOne;
    String wordTwo;
    String wordThree;

    StatusWords({
        required this.wordZero,
        required this.wordOne,
        required this.wordTwo,
        required this.wordThree,
    });

    StatusWords copyWith({
        String? wordZero,
        String? wordOne,
        String? wordTwo,
        String? wordThree,
    }) =>
        StatusWords(
            wordZero: wordZero ?? this.wordZero,
            wordOne: wordOne ?? this.wordOne,
            wordTwo: wordTwo ?? this.wordTwo,
            wordThree: wordThree ?? this.wordThree,
        );

    factory StatusWords.fromRawJson(String str) => StatusWords.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StatusWords.fromJson(Map<String, dynamic> json) => StatusWords(
        wordZero: json["word_zero"],
        wordOne: json["word_one"],
        wordTwo: json["word_two"],
        wordThree: json["word_three"],
    );

    Map<String, dynamic> toJson() => {
        "word_zero": wordZero,
        "word_one": wordOne,
        "word_two": wordTwo,
        "word_three": wordThree,
    };
}
