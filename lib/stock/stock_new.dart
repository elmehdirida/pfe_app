import 'package:app/stock/stock.dart';
import 'package:app/stock/stock_hestorie.dart';
import 'package:app/stock/stock_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../Client/client.dart';
import '../Produit/Produit.dart';
import '../navigation_drawer_widget.dart';

class StockNew extends StatefulWidget {
  const StockNew({Key? key}) : super(key: key);

  @override
  State<StockNew> createState() => _StockNewState();
}

class _StockNewState extends State<StockNew> {
  var produitlist = <Produit>[];
  List<String?> clientlist = [];
  Map<String, String> change = {
    'id': '',
    'stock_id': '',
    'produit_name': '',
    'produit_code': '',
    'produit_id': '',
    'produit_entrer': '',
  };
  final _updateqtt = {'quantite_res': ''};

  List<Map<String, String>> list = [];
  var stockhistlist = <Stockhist>[];

  String? _ClientValue;
  String? _Type;
  @override
  void initState() {
    _getproduitt();
    _getclient();
    super.initState();
  }

  final _infosave = {
    'client_id': '',
    'ref_stock':
        "Stock ${DateFormat('dd-MM-yyyy HHmm').format(DateTime.now())}",
    'type_stock': '',
    'created_at': DateTime.now().toString(),
  };
  _getstock(id) async {
    Iterable list = (await Stocks().getStockBId(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      stockhistlist = list.map((model) => Stockhist.fromJson(model)).toList();
    });
  }

  _getproduitt() async {
    Iterable list = (await Produits().getProduit()) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
    });
  }

  _getclient({int? id}) async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    if (!mounted) return;

    setState(() {
      list.map((model) => Client.fromJson(model)).toList().map((e) {
        clientlist.add('${e.id}  -  ${e.name!}');
      }).toList();
    });
    clientlist.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Ajouter Un Stock"),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 100, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                heroTag: 'save',
                onPressed: () async {
                  if (list.isNotEmpty) {
                    var x = await Stocks().addStock(_infosave, context);
                    var id = x['id'];
                    for (var item in list) {
                      item['stock_id'] = id.toString();
                      await Stockshists().addStockhist(item, context);
                      var prodid = item['produit_id'];

                      produitlist
                          .where((element) => element.id.toString() == prodid)
                          .map((e) => _updateqtt['quantite_res'] =
                              (e.quantite_res! +
                                      int.parse(item['produit_entrer']!))
                                  .toString())
                          .toList();

                      await Produits()
                          .updateProduit(_updateqtt, context, prodid, 1);
                    }
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            title: ' Stock doit contient au moins un produit',
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.done,
                            btnOkColor: Colors.red)
                        .show();
                  }
                },
                child: const Icon(
                  Icons.save,
                ),
                backgroundColor: Colors.green,
              ),
            ),
            FloatingActionButton(
              heroTag: 'back',
              onPressed: () {
                return Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
              backgroundColor: Colors.red,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 50),
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: const Color.fromARGB(255, 145, 142, 142),
                      style: BorderStyle.solid,
                      width: 1),
                ),
                child: DropdownButton<String>(
                  hint: const Text(
                    "Selectionner Un Client",
                    style: TextStyle(fontSize: 20),
                  ),
                  value: _ClientValue,
                  icon: const Icon(Icons.arrow_downward),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      list = [];
                      _ClientValue = newValue!;
                      int index = newValue!.indexOf('-');
                      newValue = newValue!.substring(0, index);
                      _infosave['client_id'] =
                          newValue!.replaceAll(RegExp(r'[^0-9]'), '');
                    });
                  },
                  items:
                      clientlist.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 50),
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: const Color.fromARGB(255, 145, 142, 142),
                      style: BorderStyle.solid,
                      width: 1),
                ),
                child: DropdownButton<String>(
                  hint: const Text(
                    "Selectionner Le Type",
                    style: TextStyle(fontSize: 20),
                  ),
                  value: _Type,
                  icon: const Icon(Icons.arrow_downward),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _Type = newValue!;
                      _infosave['type_stock'] =
                          newValue == 'Nouveau Stock' ? '0' : '1';
                    });
                  },
                  items: <String>['Nouveau Stock', 'Retour']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 50),
                child: ElevatedButton(
                    onPressed: () async {
                      await _getstock(_infosave['client_id']);

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
                                          width: w * .33,
                                          child: const Text('Nom Du\n Produit'),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: w * .33,
                                          child: const Text('QR'),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: w * .33,
                                          child: const Text('Valeur \nAjouté'),
                                        ),
                                      ),
                                    ],
                                    rows: produitlist
                                        .where((element) =>
                                            element.client_id.toString() ==
                                            _infosave['client_id'])
                                        .map((e) => DataRow(
                                            cells: newrow(
                                                e.nom_produit,
                                                e.quantite_res,
                                                e.id,
                                                e.code_produit)))
                                        .toList()),
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
                                            (list);
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
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 40,
                                                    vertical: 20))),
                                        child: const Text('Save change'),
                                        onPressed: () {
                                          Navigator.pop(context);
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
                    child: const Text("Choisi Les Produits")),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<DataCell> newrow(nomProduit, quantiteRes, prodid, codeproduit) {
    TextEditingController x = TextEditingController();
    var res = list.firstWhere(
      (element) => element['produit_id'] == prodid.toString(),
      orElse: () => {},
    )['produit_entrer'];
    if (res == null) {
      x.text = '0';
    } else {
      x.text = res;
    }
    return [
      DataCell(Text(nomProduit)),
      DataCell(Text((quantiteRes).toString())),
      DataCell(Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 50, 5),
        child: TextFormField(
          controller: x,
          onChanged: ((val) {
            change = {};
            change['produit_name'] = nomProduit;
            change['produit_id'] = prodid.toString();
            change['produit_code'] = codeproduit;
            if (val == '') {
              change['produit_entrer'] = '0';
              list.removeWhere(
                  (element) => element['produit_id'] == prodid.toString());
            } else if (val != '') {
              change['produit_entrer'] = val;
              if (list.any(
                  (element) => element['produit_id'] == prodid.toString())) {
                list.removeWhere(
                    (element) => element['produit_id'] == prodid.toString());
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
}
