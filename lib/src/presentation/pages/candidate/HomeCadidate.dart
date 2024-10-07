import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homecadidate extends StatefulWidget {
  const Homecadidate({super.key});
  static const routeName = "/homecandidate";

  @override
  State<Homecadidate> createState() => _HomecadidateState();
}

class _HomecadidateState extends State<Homecadidate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Cử tri'),
    );
  }
}

