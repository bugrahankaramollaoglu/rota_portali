import 'package:rota_portali/google_map.dart';
import 'package:flutter/material.dart';

class Stats_Screen extends StatefulWidget {
  const Stats_Screen({super.key});

  @override
  State<Stats_Screen> createState() => _Stats_ScreenState();
}

class _Stats_ScreenState extends State<Stats_Screen> {
  @override
  Widget build(BuildContext context) {
    return const MyMap();
  }
}
