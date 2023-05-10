

class PMSPayload  {
  List<String> _registersPayload = [];
  List<String> _coilsPayload = [];

  void setRegistersPayload(List<String> payload) {
    _registersPayload = payload;
  }
  void setCoilsPayload(List<String> payload) {
    _coilsPayload = payload;
  }
  List<String> getRegistersPayload() {
    return _registersPayload;
  }
  List<String> getCoilsPayload() {
    return _coilsPayload;
  }
}