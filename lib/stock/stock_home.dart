import 'package:app/stock/Stock_new.dart';
import 'package:app/stock/stock.dart';
import 'package:app/stock/stock_hestorie.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../Client/client.dart';
import '../Client/search_client.dart';
import '../Produit/Produit.dart';
import '../navigation_drawer_widget.dart';

class StockHome extends StatefulWidget {
  const StockHome({Key? key}) : super(key: key);

  @override
  State<StockHome> createState() => _StockHomeState();
}

class _StockHomeState extends State<StockHome> {
  bool isloading = true;
  var stocklist = <Stock>[];
  var stockhistlist = <Stockhist>[];
  var clientlist = <Client>[];
  var produitlist = <Produit>[];
  final _updateqtt = {'quantite_res': ''};

  Map<String, String> change = {
    'id': '',
    'stock_id': '',
    'produit_name': '',
    'produit_code': '',
    'produit_id': '',
    'produit_entrer': '',
  };
  List<Map<String, String>> list = [];

  @override
  void initState() {
    _getproduitt();
    _getstock();
    _getclient();
    super.initState();
  }

  _getproduitt() async {
    Iterable list = (await Produits().getProduit()) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getstockhist(id) async {
    Iterable list = (await Stockshists().getStockhist(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      stockhistlist = list.map((model) => Stockhist.fromJson(model)).toList();
      isloading = false;
    });
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    if (!mounted) return;

    setState(() {
      clientlist = list.map((model) => Client.fromJson(model)).toList();
    });
  }

  _getstock() async {
    Iterable list = (await Stocks().getStock()) as Iterable;
    if (!mounted) return;

    setState(() {
      stocklist = list.map((model) => Stock.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? clientname = "";

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Gérer Le Stock"),
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
                  .push(MaterialPageRoute(builder: (_) => const StockNew())),
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
          : (stocklist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: stocklist.map((stock) {
                    clientlist.map((client) {
                      if (stock.client_id == client.id) {
                        clientname = client.name;
                      }
                    }).toList();
                    return newcard(
                        context,
                        stock,
                        clientname,
                        stock.client_id,
                        stock.id,
                        stock.ref_stock,
                        stock.type_stock,
                        stock.created_at);
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

  GFCard newcard(BuildContext context, produit, clientname, clientId, id,
      refStock, typeStock, date) {
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
                      clientname,
                      style: const TextStyle(fontSize: 14),
                    ),
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
                        await _getstockhist(id);
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
                                            width: w * .35,
                                            child:
                                                const Text('Nom Du\n Produit'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .2,
                                            child:
                                                const Text('Quantité\n entré'),
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
                                            child:
                                                const Text('Valeur \nAjouté'),
                                          ),
                                        ),
                                      ],
                                      rows: stockhistlist.map((stock) {
                                        return DataRow(
                                            cells: newrow2(
                                                stock.produit_name,
                                                stock.produit_entrer,
                                                stock.produit_id,
                                                stock.produit_code,
                                                stock.stock_id,
                                                stock.id));
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
                                              list.clear();
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
                                            for (var item in list) {
                                              var id = item['id'];
                                              await Stockshists().updateStock(
                                                  item, context, id);
                                              var prodid = item['produit_id'];

                                              produitlist
                                                  .where((element) =>
                                                      element.id.toString() ==
                                                      prodid)
                                                  .map((e) => _updateqtt[
                                                      'quantite_res'] = (e
                                                              .quantite_res! +
                                                          int.parse(item[
                                                              'produit_entrer']!))
                                                      .toString())
                                                  .toList();

                                              await Produits().updateProduit(
                                                  _updateqtt,
                                                  context,
                                                  prodid,
                                                  1);
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
                        await _getstockhist(id);
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

  List<DataCell> newrow2(
      nomProduit, quantiteentre, prodid, codeproduit, id, id2) {
    int qr = 0;
    produitlist
        .where((element) => element.id == prodid)
        .map((e) => qr = e.quantite_res!)
        .toList();

    TextEditingController x = TextEditingController();
    var res = list.firstWhere(
      (element) =>
          element['produit_id'] == prodid.toString() &&
          element['stock_id'] == id.toString(),
      orElse: () => {},
    )['produit_entrer'];
    if (res == null) {
      x.text = '0';
    } else {
      x.text = res;
    }
    return [
      DataCell(Text(nomProduit)),
      DataCell(Text(quantiteentre.toString())),
      DataCell(Text((qr).toString())),
      DataCell(Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 50, 5),
        child: TextFormField(
          controller: x,
          onChanged: ((val) {
            change = {};
            change['produit_name'] = nomProduit;
            change['produit_id'] = prodid.toString();
            change['produit_code'] = codeproduit;
            change['stock_id'] = id.toString();
            change['id'] = id2.toString();
            if (val == '') {
              change['produit_entrer'] = '0';
              list.removeWhere((element) =>
                  element['produit_id'] == prodid.toString() &&
                  element['stock_id'] == id.toString());
            } else if (val != '') {
              change['produit_entrer'] =
                  (int.parse(val) + quantiteentre).toString();

              if (list.any((element) =>
                  element['produit_id'] == prodid.toString() &&
                  element['stock_id'] == id.toString())) {
                list.removeWhere((element) =>
                    element['produit_id'] == prodid.toString() &&
                    element['stock_id'] == id.toString());
                list.add(change);
              } else {
                list.add(change);
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
}
