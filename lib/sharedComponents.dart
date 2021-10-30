import 'package:flutter/material.dart';

defaultText({String text , Color color , double fSize})=>Text(
  text,
  style: TextStyle(  color:color==null ? Colors.white : color , fontSize: fSize==null ? 25 :fSize),
  textAlign: TextAlign.center,
);

defaultDecoration()=> BoxDecoration(
  color: Color(0xFF001456),
  borderRadius: BorderRadius.circular(16),
);
defaultSizedBox ({double height})=> SizedBox(height: height==null ? 8.0: height,);

defaultPadding ({double padding , @required Widget widget})=>
    Padding(padding: EdgeInsets.all(padding==null? 8.0 : 16.0) , child: widget,);