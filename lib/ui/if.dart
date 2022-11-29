import 'package:flutter/material.dart';

class If extends StatelessWidget {
  final bool expect;
  final Function then;
  final Function or;

  const If({
    Key key,
    @required this.or,
    @required this.then,
    @required this.expect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expect) {
      return then();
    } else {
      return or();
    }
  }
}
