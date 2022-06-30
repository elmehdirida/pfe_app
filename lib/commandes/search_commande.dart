// ignore_for_file: avoid_unnecessary_containers, unused_field

import 'dart:convert';
import '../Client/client.dart';
import 'Commande_Home.dart';
import 'package:app/commandes/commande.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchCommande extends StatefulWidget {
  const SearchCommande({Key? key}) : super(key: key);

  @override
  State<SearchCommande> createState() => _SearchCommandeState();
}

class _SearchCommandeState extends State<SearchCommande> {
  @override
  void initState() {
    _getclient();
    super.initState();
  }

  final _searchsontroller = TextEditingController();
  var commandelist = <Commande>[];
  List clientlist = [];
  var clientname;
  var searchItem = '';
  void searchonchange(String item) {
    setState(() {
      searchItem = item;
    });
    _get();
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    setState(() {
      clientlist = list.map((model) => Client.fromJson(model)).toList();
    });
  }

  _get() async {
    Iterable list = (await search(searchItem)) as Iterable;
    if (!mounted) return;
    setState(() {
      commandelist = list.map((item) => Commande.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              onChanged: (val) {
                searchonchange(_searchsontroller.text);
              },
              controller: _searchsontroller,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchsontroller.clear();
                      setState(() {
                        commandelist = [];
                      });
                    },
                  ),
                  hintText: 'Trouver Une Commande',
                  border: InputBorder.none),
            ),
          ),
        )),
        body: commandelist.isNotEmpty
            ? ListView(
                children: commandelist.map((item) {
                  clientlist.map((client) {
                    if (item.client_id == client.id) {
                      clientname = client.name;
                    }
                  }).toList();
                  return newCard(
                      context,
                      item.client_id,
                      item.commentaire,
                      item.created_at,
                      item.etat,
                      item.name,
                      item.id,
                      clientname);
                }).toList(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Aucune Resultat',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ));
  }
}

Future<List?> search(name) async {
  String baseUrl = 'http://127.0.0.1:8000/api/commande/$name';
  try {
    http.Response response =
        await http.get(Uri.parse(baseUrl)).then((value) => value);
    if (response.statusCode == 200) {
      var extractedData = json.decode(response.body);
      return extractedData;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
