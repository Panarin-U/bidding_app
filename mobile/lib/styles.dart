


import 'package:bidding_app/color_utils.dart';
import 'package:flutter/cupertino.dart';

class Styles {

  static final colorButtonPrimary = HexColor.fromHex('#12284C');
  static final colorTextPrimary = HexColor.fromHex('#393F49');
  static final colorTextSecondary = HexColor.fromHex('#586782');

  static final _font = TextStyle(fontFamily: 'OpenSans', fontSize: 14, color: colorTextPrimary);

  static final light = _font.copyWith(fontWeight: FontWeight.w300);
  static final regular = _font.copyWith(fontWeight: FontWeight.normal);
  static final medium = _font.copyWith(fontWeight: FontWeight.w600);
  static final bold = _font.copyWith(fontWeight: FontWeight.w700);
  


}