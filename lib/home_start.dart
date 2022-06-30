import 'package:app/Client/att.dart';
import 'package:app/Client/client_att.dart';
import 'package:app/Client/client_page.dart';
import 'package:app/navigation_drawer_widget.dart';
import 'package:app/user/servives/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStart extends StatefulWidget {
  const HomeStart({Key? key}) : super(key: key);

  @override
  State<HomeStart> createState() => _HomeStartState();
}

class _HomeStartState extends State<HomeStart> {
  var clienatt = <Att>[];
  @override
  void initState() {
    _getatt();
    super.initState();
  }

  _getatt() async {
    Iterable list = (await Atts().getAtt()) as Iterable;
    clienatt = list.map((model) => Att.fromJson(model)).toList();
    if (!mounted) return;

    setState(() {
      att = clienatt.length;
    });
  }

  int? att;
  @override
  Widget build(BuildContext context) {
    print(Provider.of<Auth>(context, listen: true).role);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              const Tab(
                icon: Icon(Icons.account_box),
                text: ('Client'),
              ),
              Tab(
                icon: const Icon(Icons.person_add),
                child: Text(
                  att.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
          title: const Text("Home"),
        ),
        body: const TabBarView(children: [AccountPage(), atts()]),
      ),
    );
  }
}
