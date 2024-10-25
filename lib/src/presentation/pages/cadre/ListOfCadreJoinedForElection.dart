import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListOfCadreJoinedForElection extends StatefulWidget {
  static const routeName = 'List-Of-Cadre-Joined-For-Election';
  final String ID_CanBo;
  const ListOfCadreJoinedForElection({super.key, required this.ID_CanBo});

  @override
  State<ListOfCadreJoinedForElection> createState() => _ListOfCadreJoinedForElectionState(ID_CanBo: ID_CanBo);
}

class _ListOfCadreJoinedForElectionState extends State<ListOfCadreJoinedForElection> {
  final String ID_CanBo;

  _ListOfCadreJoinedForElectionState({required this.ID_CanBo});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
