import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter(
      {int decimalRange = 0, bool activatedNegativeValues = false})
      : assert(
            decimalRange >= 0, 'DecimalTextInputFormatter declaration error') {
    String dp = (decimalRange > 0) ? '([.][0-9]{0,$decimalRange}){0,1}' : '';
    String num = '[0-9]*$dp';

    if (activatedNegativeValues) {
      _exp = new RegExp('^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$');
    } else {
      _exp = new RegExp('^($num){0,1}\$');
    }
  }

  late RegExp _exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
