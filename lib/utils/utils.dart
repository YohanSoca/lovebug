import 'dart:ui';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0x66000000);
}

bool checkBit(int value, int bit) => (value & (1 << bit)) != 0;