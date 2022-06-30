// ignore_for_file: use_build_context_synchronously

import 'package:app/sortie/sortie.dart';
import 'package:app/sortie/sortie_hestorie.dart';
import 'package:app/sortie/sortie_new.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../Client/client.dart';
import '../Client/search_client.dart';
import '../Produit/Produit.dart';
import '../navigation_drawer_widget.dart';
import 'package:auto_reload/auto_reload.dart';

class SortieHome extends StatefulWidget {
  const SortieHome({Key? key}) : super(key: key);

  @override
  State<SortieHome> createState() => _SortieHomeState();
}

abstract class _AutoReloadState extends State<SortieHome>
    implements AutoReloader {}

class _SortieHomeState extends _AutoReloadState with AutoReloadMixin {
  final Duration autoReloadDuration = const Duration(seconds: 3);

  Map<String, String> dif = {
    'id_s': '',
    'nv': '',
  };
  List<Map<String, String>> diff = [];
  bool isloading = true;
  var sortielist = <Sortie>[];
  var sortiehistlist = <Sortiehist>[];
  var clientlist = <Client>[];
  var produitlist = <Produit>[];
  Map<String, String> change = {
    'id': '',
    'sortie_id': '',
    'produit_name': '',
    'produit_code': '',
    'produit_id': '',
    'produit_entrer': '',
  };
  List<Map<String, String>> list2 = [];
  var qr;

  @override
  void initState() {
    _getproduitt();
    _getclient();
    _getsortie();
    startAutoReload();

    super.initState();
  }

  @override
  void dispose() {
    cancelAutoReload();
    super.dispose();
  }

  _getproduitt() async {
    Iterable list = (await Produits().getProduit()) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getsortiehist(id) async {
    Iterable list = (await Sortieshists().sortiehist(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      sortiehistlist = list.map((model) => Sortiehist.fromJson(model)).toList();
    });
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    if (!mounted) return;

    setState(() {
      clientlist = list.map((model) => Client.fromJson(model)).toList();
    });
  }

  _getsortie() async {
    Iterable list = (await Sorties().getSortie()) as Iterable;
    if (!mounted) return;

    setState(() {
      sortielist = list.map((model) => Sortie.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? clientname = "";

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text("Gérer La Sortie"),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton.extended(
                label: const Text("Filter par client"),
                heroTag: 'filter',
                onPressed: () {}),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SortieNew())),
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: 'search',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              child: const Icon(Icons.search),
            ),
          ],
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (sortielist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: sortielist.map((sortie) {
                    clientlist.map((client) {
                      if (sortie.client_id == client.id) {
                        clientname = client.name;
                      }
                    }).toList();
                    return newcard(
                        context,
                        sortie,
                        clientname,
                        sortie.client_id,
                        sortie.id,
                        sortie.ref_sortie,
                        sortie.nbr_commande,
                        sortie.etat_bs,
                        sortie.facture_id,
                        sortie.created_at);
                  }).toList(),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'No Data | Server error',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                )),
    );
  }

  GFCard newcard(BuildContext context, sortie, clientname, clientId, id,
      refSortie, nbrCom, etat, facture, date) {
    final double w = MediaQuery.of(context).size.width;

    return GFCard(
      color: const Color.fromARGB(79, 159, 137, 137),
      buttonBar: GFButtonBar(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Text(refSortie, style: const TextStyle(fontSize: 13)),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Nbr : $nbrCom",
                    ),
                    Text(
                      etat == 0 ? 'Facturé' : 'Non Facturé',
                      style: TextStyle(
                          color: etat == 0
                              ? const Color.fromARGB(255, 7, 109, 10)
                              : const Color.fromARGB(255, 252, 11, 11)),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sortie Normal ",
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    Text(
                      clientname,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date).toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _getsortiehist(id);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            final double w = MediaQuery.of(context).size.width;

                            return SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  DataTable(
                                      columnSpacing: 10,
                                      horizontalMargin: 15,
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .3,
                                            child:
                                                const Text('Nom Du\n Produit'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .25,
                                            child: const Text('Code \nProduit'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .1,
                                            child: const Text('QR'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .35,
                                            child: const Text('New\nValue'),
                                          ),
                                        ),
                                      ],
                                      rows: sortiehistlist.map((sortie) {
                                        produitlist.map((produit) {
                                          if (produit.id == sortie.produit_id) {
                                            qr = produit.quantite_res;
                                          }
                                        }).toList();
                                        return DataRow(
                                            cells: newrow2(
                                                sortie.produit_name,
                                                sortie.produit_entrer,
                                                sortie.produit_id,
                                                sortie.produit_code,
                                                qr,
                                                sortie.sortie_id,
                                                sortie.id));
                                      }).toList()),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 40,
                                                            vertical: 20))),
                                            child: const Text('reset'),
                                            onPressed: () {
                                              list2.clear();
                                              diff.clear();
                                              Navigator.pop(context);
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 20))),
                                          child: const Text('Save change'),
                                          onPressed: () async {
                                            for (var item in list2) {
                                              var id = item['id'];
                                              await Sortieshists().updateSortie(
                                                  item, context, id);
                                              var l1 = {'quantite_res': ''};
                                              l1['quantite_res'] =
                                                  diff.firstWhere((element) =>
                                                      element['id_s'] ==
                                                      item['id'])['nv']!;
                                              var idP = item['produit_id'];
                                              await Produits().updateProduit(
                                                  l1, context, idP, 2);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _getsortiehist(id);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  DataTable(
                                      columnSpacing: 10,
                                      horizontalMargin: 15,
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .33,
                                            child:
                                                const Text('Nom Du\n Produit'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .33,
                                            child: const Text('Code'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .33,
                                            child:
                                                const Text('Quantite\n Sortie'),
                                          ),
                                        ),
                                      ],
                                      rows: sortiehistlist.map((sortie) {
                                        return DataRow(
                                            cells: newrow(
                                                sortie.produit_name,
                                                sortie.produit_code,
                                                sortie.produit_entrer));
                                      }).toList()),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 20))),
                                          child: const Text('Fermer'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<DataCell> newrow2(
      nomProduit, quantiteSor, prodid, codeproduit, qr, id, id2) {
    TextEditingController x = TextEditingController();

    var res = list2.firstWhere(
      (element) =>
          element['produit_id'] == prodid.toString() &&
          element['sortie_id'] == id.toString(),
      orElse: () => {},
    )['produit_entrer'];
    if (res == null) {
      x.text = quantiteSor.toString();
    } else {
      x.text = res;
    }
    return [
      DataCell(Text(nomProduit)),
      DataCell(Text(codeproduit)),
      DataCell(Text(qr.toString())),
      DataCell(Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 50, 5),
        child: TextFormField(
          controller: x,
          onChanged: ((val) {
            change = {};
            dif = {};
            dif['id_s'] = id2.toString();
            change['produit_entrer'] = val;
            change['produit_name'] = nomProduit;
            change['produit_id'] = prodid.toString();
            change['produit_code'] = codeproduit;
            change['sortie_id'] = id.toString();
            change['id'] = id2.toString();

            if (val == '') {
              list2.removeWhere((element) =>
                  element['produit_id'] == prodid.toString() &&
                  element['sortie_id'] == id.toString());
              diff.removeWhere((element) => element["id_s"] == id2.toString());
            } else if (val != '') {
              dif['nv'] = (qr - int.parse(val) + quantiteSor).toString();
              if (int.parse(val) > qr + quantiteSor) {
                change['produit_entrer'] = (qr + quantiteSor).toString();
                dif['nv'] = '0';
                if (list2.any((element) =>
                    element['produit_id'] == prodid.toString() &&
                    element['sortie_id'] == id.toString())) {
                  list2.removeWhere((element) =>
                      element['produit_id'] == prodid.toString() &&
                      element['sortie_id'] == id.toString());
                  list2.add(change);

                  diff.removeWhere(
                      (element) => element["id_s"] == id2.toString());
                  diff.add(dif);
                }

                x.text = (qr + quantiteSor).toString();
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        content: const Text('Quantité Insfusante'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('Ok'))
                        ],
                      );
                    });
              } else {
                if (list2.any((element) =>
                    element['produit_id'] == prodid.toString() &&
                    element['sortie_id'] == id.toString())) {
                  list2.removeWhere((element) =>
                      element['produit_id'] == prodid.toString() &&
                      element['sortie_id'] == id.toString());
                  list2.add(change);
                  diff.removeWhere(
                      (element) => element["id_s"] == id2.toString());
                  diff.add(dif);
                } else {
                  list2.add(change);
                  diff.add(dif);
                }
              }
            }
          }),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      )),
    ];
  }

  List<DataCell> newrow(nomProduit, codeproduit, produitentrer) {
    return [
      DataCell(Text(nomProduit)),
      DataCell(Text(codeproduit)),
      DataCell(Text(produitentrer.toString())),
    ];
  }

  @override
  void autoReload() {
    setState(() {
      _getsortie();
    });
  }
}
