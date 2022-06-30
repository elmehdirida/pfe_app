import 'package:app/stock/Stock_new.dart';
import 'package:app/stock/stock.dart';
import 'package:app/stock/stock_hestorie.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Produit/Produit.dart';
import '../servives/auth.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  bool isloading = true;
  var stocklist = <Stock>[];
  var stockhistlist = <Stockhist>[];
  var produitlist = <Produit>[];
  var id;
  @override
  void initState() {
    id = Provider.of<Auth>(context, listen: false).client.id;

    _getproduitt();
    _getstock();
    super.initState();
  }

  _getproduitt() async {
    Iterable list = (await Produits().userproduit(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getstockhist(ids) async {
    Iterable list = (await Stockshists().getStockhist(ids)) as Iterable;
    if (!mounted) return;
    setState(() {
      stockhistlist = list.map((model) => Stockhist.fromJson(model)).toList();
    });
  }

  _getstock() async {
    Iterable list = (await Stocks().getStockBId(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      stocklist = list.map((model) => Stock.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (stocklist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: stocklist.map((stock) {
                    return newcard(context, stock, stock.client_id, stock.id,
                        stock.ref_stock, stock.type_stock, stock.created_at);
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

  GFCard newcard(
      BuildContext context, produit, clientId, ids, refStock, typeStock, date) {
    final double w = MediaQuery.of(context).size.width;

    return GFCard(
      color: const Color.fromARGB(79, 159, 137, 137),
      buttonBar: GFButtonBar(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Text(refStock, style: const TextStyle(fontSize: 13)),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      typeStock == 0 ? 'Nouveau Stock' : 'Retour',
                      style: TextStyle(
                          color: typeStock == 0
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
                    Text(
                      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date).toString(),
                      style: const TextStyle(fontSize: 12),
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
                        await _getstockhist(ids);
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
                                                const Text('Quantite\n entrer'),
                                          ),
                                        ),
                                      ],
                                      rows: stockhistlist.map((stock) {
                                        return DataRow(
                                            cells: newrow(
                                                stock.produit_name,
                                                stock.produit_code,
                                                stock.produit_entrer));
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
}
