import 'package:flutter/material.dart';


const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
  // This is for when it is selected
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
);


//
// Expanded(
// child: TextLiquidFill(
// text: 'Registeration',
// waveColor: Colors.lightBlueAccent,
// boxBackgroundColor: Colors.white,
// textStyle: GoogleFonts.pacifico(
// fontSize: 60.0,
// fontWeight: FontWeight.bold,
// ),
// boxHeight: 200.0,
// ),
// ),