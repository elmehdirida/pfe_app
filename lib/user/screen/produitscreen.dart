import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../Produit/Produit.dart';
import '../servives/auth.dart';

class Produitscreen extends StatefulWidget {
  const Produitscreen({Key? key}) : super(key: key);

  @override
  _ProduitscreenState createState() => _ProduitscreenState();
}

class _ProduitscreenState extends State<Produitscreen> {
  var produitlist = <Produit>[];
  var id;
  _getproduitt() {
    id = Provider.of<Auth>(context, listen: false).client.id;
  }

  @override
  void initState() {
    _getproduitt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Produit>>(
              initialData: const <Produit>[],
              future: userproduit(id),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                }

                return DataTable(
                  columnSpacing: 10,
                  horizontalMargin: 15,
                  headingRowColor: MaterialStateProperty.all(Colors.amber[200]),
                  columns: [
                    DataColumn(
                        label: SizedBox(
                      width: w * .35,
                      child: const Text('Nom \nProduit'),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: w * .35,
                      child: const Text('Code \nPoduit'),
                    )),
                    DataColumn(
                      label: SizedBox(
                        width: w * .3,
                        child: const Text('Quantité \nrestante'),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    snapshot.data!.length,
                    (index) {
                      var value = snapshot.data![index];
                      return DataRow(cells: [
                        DataCell(
                          Text(value.nom_produit!),
                        ),
                        DataCell(
                          Text(value.code_produit!),
                        ),
                        DataCell(
                          Text(value.quantite_res!.toString()),
                        ),
                      ]);
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Produit>>? userproduit(id) async {
  String baseUrl = 'http://127.0.0.1:8000/api/user/produits/$id';
  try {
    http.Response response = await http.get(Uri.parse(baseUrl)).then((value) {
      return value;
    });
    if (response.statusCode == 200) {
      var extractedData =
          json.decode(response.body).cast<Map<String, dynamic>>();
      List<Produit> list = await extractedData
          .map<Produit>((json) => Produit.fromJson(json))
          .toList();
      return list;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
