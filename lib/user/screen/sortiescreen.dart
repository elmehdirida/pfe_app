// ignore_for_file: use_build_context_synchronously

import 'package:app/sortie/sortie.dart';
import 'package:app/sortie/sortie_hestorie.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:auto_reload/auto_reload.dart';
import 'package:provider/provider.dart';

import '../../Produit/Produit.dart';
import '../servives/auth.dart';

class SortieScreen extends StatefulWidget {
  const SortieScreen({Key? key}) : super(key: key);

  @override
  State<SortieScreen> createState() => _SortieScreenState();
}

abstract class _AutoReloadState extends State<SortieScreen>
    implements AutoReloader {}

class _SortieScreenState extends _AutoReloadState with AutoReloadMixin {
  final Duration autoReloadDuration = const Duration(seconds: 3);

  bool isloading = true;
  var sortielist = <Sortie>[];
  var sortiehistlist = <Sortiehist>[];
  var produitlist = <Produit>[];
  var id;
  @override
  void initState() {
    id = Provider.of<Auth>(context, listen: false).client.id;
    _getproduitt();
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
    Iterable list = (await Produits().userproduit(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getsortiehist(ids) async {
    Iterable list = (await Sortieshists().sortiehist(ids)) as Iterable;
    if (!mounted) return;
    setState(() {
      sortiehistlist = list.map((model) => Sortiehist.fromJson(model)).toList();
    });
  }

  _getsortie() async {
    Iterable list = (await Sorties().usersortie(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      sortielist = list.map((model) => Sortie.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (sortielist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: sortielist.map((sortie) {
                    return newcard(
                        context,
                        sortie,
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

  GFCard newcard(BuildContext context, sortie, clientId, ids, refSortie, nbrCom,
      etat, facture, date) {
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
                        await _getsortiehist(ids);
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
