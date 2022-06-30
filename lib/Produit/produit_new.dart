import 'package:app/Produit/Produit.dart';
import 'package:flutter/material.dart';

import '../Client/client.dart';

class ProduitNew extends StatefulWidget {
  const ProduitNew({Key? key}) : super(key: key);

  @override
  State<ProduitNew> createState() => _ProduitNewState();
}

class _ProduitNewState extends State<ProduitNew> {
  String? dropdownValue;
  List<String?> clientlist = [];

  _getclient({int? id}) async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    setState(() {
      list.map((model) => Client.fromJson(model)).toList().map((e) {
        clientlist.add('${e.id}  -  ${e.name!}');
      }).toList();
    });
    clientlist.sort();
  }

  TextEditingController nomController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    _getclient();
    super.initState();
  }

  final _infosave = {
    'nom_produit': '',
    'code_produit': '',
    'client_id': '',
    'quantite_res': '0',
    'created_at': '',
  };

  final GlobalKey<FormState> _clientform = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Un Produit'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pop(context);
            },
            heroTag: 'Anuller',
            label: const Text('Anuller'),
            icon: const Icon(Icons.exit_to_app),
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.green,
            heroTag: 'Save',
            onPressed: () {
              _submit(context);
            },
            label: const Text('Save'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _clientform,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Nouveau Produit",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'can not be empty';
                        } else if (val.length < 5) {
                          return 'Minimum taille is six characteres';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['nom_produit'] = val!;
                      },
                      controller: nomController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Nom Du Produit',
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'can not be empty';
                        } else if (val.length < 5) {
                          return 'Minimum taille is six characteres';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['code_produit'] = val!;
                      },
                      controller: codeController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Code Du Produit',
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 53,
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: const Color.fromARGB(255, 145, 142, 142),
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        "Selectionner Un Client",
                        style: TextStyle(fontSize: 20),
                      ),
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                      ),
                      items: clientlist
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          int index = newValue!.indexOf('-');
                          newValue = newValue!.substring(0, index);
                          _infosave['client_id'] =
                              newValue!.replaceAll(RegExp(r'[^0-9]'), '');
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext ctx) {
    if (_clientform.currentState!.validate()) {
      _clientform.currentState!.save();

      Produits().addProduit(_infosave, ctx);
    }
  }
}
