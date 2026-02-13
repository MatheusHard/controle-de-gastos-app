import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

import '../../constants/colors/app_colors.dart';

class AppGradients {

  static const boxPetGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black38
      ]);

  static  LinearGradient buttonSentimento =  const LinearGradient(
    //  begin: Alignment.topCenter,
     // end: Alignment.bottomCenter,

      colors: [
        Color(0xFF6363DB),
        Color(0xFF6363DB),
      ]);

  static  LinearGradient redColor =  const LinearGradient(
      colors: [
        AppColors.red,
        AppColors.red,
      ]);


  static const petFemea =  LinearGradient(
      begin: Alignment.topCenter,
      end: AlignmentDirectional.bottomEnd,
      colors: [
        Color(0xffffafbd),
        Color(0xffffc3a0)
      ]);

  static const redGradient =  LinearGradient(
      begin: Alignment.topCenter,
      end: AlignmentDirectional.bottomEnd,
      colors: GradientColors.red );

  static const LinearGradient loginGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: AlignmentDirectional.bottomEnd,
      colors: [

        Color(0xff2193b0),
        Color(0xff6dd5ed)
      ]);
  static const linear = LinearGradient(colors: [
    Color(0xFF57B6E5),
    Color.fromRGBO(130, 87, 229, 0.695),
  ], stops: [
    0.0,
    0.695
  ], transform: GradientRotation(2.13959913 * pi));

static const sol =
  LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment(0.8, 1),
  colors: <Color>[
  Color(0xff1f005c),
  Color(0xff5b0060),
  Color(0xff870160),
  Color(0xffac255e),
  Color(0xffca485c),
  Color(0xffe16b5c),
  Color(0xfff39060),
  Color(0xffffb56b),
  ], // Gradient from https://learnui.design/tools/gradient-generator.html
  tileMode: TileMode.mirror,
  );

  static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000), // preto puro
      Color(0xFF1C1C1C), // cinza bem escuro
      Color(0xFF2E2E2E), // cinza médio
    ],
  );

  static const LinearGradient darkBlueGradient = LinearGradient(
    colors: [
      Color(0xFF0F2027), // azul quase preto
      Color(0xFF203A43), // azul petróleo
      Color(0xFF2C5364), // azul profundo
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackPurpleGradient = LinearGradient(
    colors: [
      Color(0xFF000000), // preto
      Color(0xFF2C003E), // roxo bem escuro
      Color(0xFF5A189A), // roxo mais vivo
    ],
    stops: [0.0, 0.5, 1.0],
    transform: GradientRotation(pi / 4),
  );


}
