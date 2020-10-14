import 'package:flutter/material.dart';

const Color bglightColor = Color(0xFF202438);
const Color bgColor = Color(0xFF1E202C);
const Color bgdarkColor = Color(0xFF0E0E12);
const Color lightColor = Color(0xFFAFB6C5);
const Color good = Color(0xFF51a832);
const Color semi_good = Color(0xff97b51d);
const Color neutral = Color(0xFFcbcfbe);
const Color semi_bad = Color(0xFFc27f1b);
const Color bad = Color(0xffb52f1d);

getStyle(double winrate) {
  winrate *= 100;
  print(winrate);
  if (winrate > 50.8) {
    if (winrate > 52.5) {
      return winrateStyle['good'];
    } else
      return winrateStyle['semi_good'];
  } else if (winrate < 49.1) {
    if (winrate > 47.5)
      return winrateStyle['semi_bad'];
    else
      return winrateStyle['bad'];
  } else {
    return winrateStyle['neutral'];
  }
}

const winrateStyle = {
  'good': TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: good,
  ),
  'semi_good': TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: semi_good,
  ),
  'neutral': TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: neutral,
  ),
  'semi_bad': TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: semi_bad,
  ),
  'bad': TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: bad,
  ),
};

const titleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const subtitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: lightColor,
);

const chosenStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: Colors.white,
);

const notChosenStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: bgdarkColor,
);
