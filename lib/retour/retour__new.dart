import 'package:app/retour/retour_.dart';
import 'package:app/retour/retour_hestorie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../Client/client.dart';
import '../navigation_drawer_widget.dart';

class RetourNew extends StatefulWidget {
  const RetourNew({Key? key}) : super(key: key);

  @override
  State<RetourNew> createState() => _RetourNewState();
}

class _RetourNewState extends State<RetourNew> {
  var produitlist = <Retourhist>[];
  List<String?> clientlist = [];
  Map<String, String> change = {
    'ref': '',
    'retour_ref': '',
    'name_societe': '',
  };

  List<Map<String, String>> rethest = [];
  String? _ClientValue;
  @override
  void initState() {
    _getclient();
    super.initState();
  }

  var societeController = TextEditingController();
  var codebarreController = TextEditingController();
  final _infosave = {
    'client_id': '',
    'ref_retour':
        "Retour ${DateFormat('dd-MM-yyyy HHmm').format(DateTime.now())}",
    'name_societe': '',
    'nbr_commande': '',
    'created_at': DateTime.now().toString(),
  };
  final GlobalKey<FormState> _clientform = GlobalKey();
  _getclient() async {
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
        title: const Text("Ajouter Un Retour"),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 80, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                heroTag: 'save',
                onPressed: () async {
                  if (rethest.length > 0) {
                    for (var element in rethest) {
                      await Retourhists().addretourhestorie(element);
                    }
                    await Retours().addRetour(_infosave, context);
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            title:
                                ' Reour doit contient au moins un code a barre',
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.done,
                            btnOkColor: Colors.red)
                        .show();
                  }
                },
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.save,
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'back',
              onPressed: () {
                return Navigator.pop(context);
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.arrow_back),
            )
          ],
        ),
      ),
      body: Form(
        key: _clientform,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 10),
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
                        _ClientValue = newValue!;
                        int index = newValue!.indexOf('-');
                        newValue = newValue!.substring(0, index);
                        _infosave['client_id'] =
                            newValue!.replaceAll(RegExp(r'[^0-9]'), '');
                      });
                    },
                    items: clientlist
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 20),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'can not be empty';
                  } else if (val.length < 5) {
                    return 'Minimum taille is six characteres';
                  }
                  return null;
                },
                onChanged: (val) {
                  if (val != '') {
                    _infosave["name_societe"] = val;
                  }
                },
                controller: societeController,
                decoration: const InputDecoration(
                  label: Text(
                    'Nom De la societe',
                    style: TextStyle(fontSize: 20),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 20, 20),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'can not be empty';
                  } else if (val.length < 5) {
                    return 'Minimum taille is six characteres';
                  }
                  return null;
                },
                controller: codebarreController,
                decoration: const InputDecoration(
                  label: Text(
                    '#Code a Barre ',
                    style: TextStyle(fontSize: 20),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          change = {};
                          change['retour_ref'] = _infosave['ref_retour']!;
                          change['ref'] = codebarreController.text;
                          change['name_societe'] = societeController.text;

                          if (_clientform.currentState!.validate()) {
                            if (rethest.any(
                                (element) => element['ref'] == change['ref'])) {
                              rethest.removeWhere(
                                  (element) => element['ref'] == change['ref']);
                              rethest.add(change);
                            } else {
                              rethest.add(change);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                        ),
                        child: const Text("Save"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              final double w =
                                  MediaQuery.of(context).size.width;

                              return SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    DataTable(
                                        columnSpacing: 10,
                                        horizontalMargin: 15,
                                        columns: [
                                          DataColumn(
                                            label: SizedBox(
                                              width: w * .75,
                                              child: const Text('Code a Barre'),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: w * .25,
                                              child: const Text("delete"),
                                            ),
                                          ),
                                        ],
                                        rows: rethest
                                            .map((e) => DataRow(
                                                cells: newrow(context, e)))
                                            .toList()),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 45, 2, 53)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                        ),
                        child: const Text("show code"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DataCell> newrow(context, his) {
    return [
      DataCell(Text(his['ref'])),
      DataCell(
        IconButton(
            onPressed: () {
              rethest.removeWhere((element) => element['ref'] == his['ref']);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_forever)),
      )
    ];
  }
}
