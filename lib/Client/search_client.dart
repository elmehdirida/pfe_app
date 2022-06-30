// ignore_for_file: avoid_unnecessary_containers, unused_field

import 'dart:convert';

import 'package:app/Client/client_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'client.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchsontroller = TextEditingController();
  var clientlist = <Client>[];

  var searchItem = '';
  void searchonchange(String item) {
    setState(() {
      searchItem = item;
    });
    _getclient();
  }

  _getclient() async {
    Iterable list = (await searchClient(searchItem)) as Iterable;
    if (!mounted) return;
    setState(() {
      clientlist = list.map((item) => Client.fromJson(item)).toList();
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
                        clientlist = [];
                      });
                    },
                  ),
                  hintText: 'Trouver Un client',
                  border: InputBorder.none),
            ),
          ),
        )),
        body: clientlist.isNotEmpty
            ? ListView(
                children: clientlist.map((client) {
                  return NewCard(context, client, client.name, client.contact,
                      client.adresse);
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

Future<List?> searchClient(name) async {
  String baseUrl = 'http://127.0.0.1:8000/api/client/search/$name';
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
