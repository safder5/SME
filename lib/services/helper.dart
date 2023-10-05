import 'dart:core';

import 'package:flutter/material.dart';

import '../constants.dart';

String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Name is REquired";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String? validateOrderNo(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Order no. is required";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "Order No should only contain Digits";
  }
  return null;
}

String? validateDate(String? value) {
  String pattern =
      r'^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return ' Date is Required';
  } else if (!regExp.hasMatch(value ?? '')) {
    return 'Must be in the format dd-mm-yyyy';
  }
  return null;
}


InputDecoration getInputDecoration(
    {required String hint, required Color errorColor}) {
  return InputDecoration(
    constraints: const BoxConstraints(maxWidth: 600, minWidth: 200),
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    hintText: hint,
    hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: b32),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: blue, width: 1.0)),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: b.withOpacity(0.1)),
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
}

// getDropDown({required String name,required List list}){
//   ret
// }

String generateSalesOrderID() {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  // final day = DateTime.now().day;
  // final month = DateTime.now().month;
  // final time = DateTime.now().hour;
  // final min = DateTime.now().minute;
  // id += '$day''$month''$time''$min';
  return id;
}

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:t,
      child: Center(
        child: CircularProgressIndicator(
          color: blue,
          strokeWidth: 1,
        ),
      ),
    );
  }
}

class LoadingOverlayHome extends StatelessWidget {
  const LoadingOverlayHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color:w.withOpacity(0.75),
        child: Center(
          child: CircularProgressIndicator(
            color: blue,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}