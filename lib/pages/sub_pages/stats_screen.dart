import 'package:backpack_pal/google_map.dart';
import 'package:backpack_pal/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
