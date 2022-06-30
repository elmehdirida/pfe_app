import 'package:app/Auth/login.dart';
import 'package:app/home_start.dart';
import 'package:app/user/servives/auth.dart';
import 'package:app/user/userhome.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class route extends StatefulWidget {
  const route({Key? key}) : super(key: key);

  @override
  State<route> createState() => _routeState();
}

class _routeState extends State<route> {
  final storage = const FlutterSecureStorage();
  void _attemptauth() async {
    final key = await storage.read(key: 'auth');
    if (key != null) {
      Provider.of<Auth>(context, listen: false).attempt(key);
    }
  }

  @override
  void initState() {
    _attemptauth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Auth>(context, listen: true).authenticated) {
      if (Provider.of<Auth>(context, listen: true).role == 1) {
        return HomeStart();
      } else {
        return Userhome();
      }
    } else {
      return LoginPage();
    }
  }
}
