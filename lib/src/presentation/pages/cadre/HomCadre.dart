import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeCadre extends StatefulWidget {
  const HomeCadre({super.key});
  static const routeName = "/homecadre";

  @override
  State<HomeCadre> createState() => _HomeCadreState();
}

class _HomeCadreState extends State<HomeCadre> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Cán bộ'),
    );
  }
}

