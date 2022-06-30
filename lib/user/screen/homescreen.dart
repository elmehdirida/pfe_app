import 'dart:io';

import 'package:app/commandes/commande.dart';
import 'package:app/retour/retour_.dart';
import 'package:app/sortie/sortie.dart';
import 'package:app/stock/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Produit/Produit.dart';
import '../servives/auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var id;
  String? name;
  var produitlist = <Produit>[];
  var stocklist = <Stock>[];
  var commandelist = <Commande>[];
  var retourlist = <Retour>[];
  var sortielist = <Sortie>[];

  @override
  void initState() {
    id = Provider.of<Auth>(context, listen: false).client.id;
    name = Provider.of<Auth>(context, listen: false).client.name;
    _getproduitt();
    _getcommande();
    _getstock();
    _getsortie();
    _getretour();

    super.initState();
  }

  _getproduitt() async {
    Iterable list = (await Produits().userproduit(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getcommande() async {
    Iterable list = (await Commandes().usercommande(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      commandelist = list.map((model) => Commande.fromJson(model)).toList();
    });
  }

  _getstock() async {
    Iterable list = (await Stocks().getStockBId(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      stocklist = list.map((model) => Stock.fromJson(model)).toList();
    });
  }

  _getsortie() async {
    Iterable list = (await Sorties().usersortie(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      sortielist = list.map((model) => Sortie.fromJson(model)).toList();
    });
  }

  _getretour() async {
    Iterable list = (await Retours().userretour(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      retourlist = list.map((model) => Retour.fromJson(model)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 10),
              const Text(
                'Bienvenue',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text(
                  name!,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1.0)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: const Icon(
                            Icons.card_travel,
                            color: Colors.black,
                            size: 30,
                          )),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Mes Produits',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              produitlist.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 20, 20),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1.0)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: const Icon(
                            Icons.assessment,
                            color: Colors.black,
                            size: 30,
                          )),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Mes commandes',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              commandelist.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 20, 20),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1.0)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: const Icon(
                            Icons.cabin,
                            color: Colors.black,
                            size: 30,
                          )),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Mes Stocks',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              stocklist.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 20, 20),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1.0)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: const Icon(
                            Icons.next_plan,
                            color: Colors.black,
                            size: 30,
                          )),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Mes Sorties',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              sortielist.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 20, 20),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1.0)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: const Icon(
                            Icons.undo,
                            color: Colors.black,
                            size: 30,
                          )),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Mes Reours',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              retourlist.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 20, 20),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
