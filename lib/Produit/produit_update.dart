import 'package:app/Produit/Produit.dart';
import 'package:flutter/material.dart';

import '../Client/client.dart';

class ProduitUpdate extends StatefulWidget {
  final Produit? produitpass;
  final String? clientname;
  const ProduitUpdate({Key? key, this.produitpass, this.clientname})
      : super(key: key);

  @override
  State<ProduitUpdate> createState() => _ProduitUpdateState();
}

class _ProduitUpdateState extends State<ProduitUpdate> {
  List<String?> clientlist = [];

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    setState(() {
      list.map((model) => Client.fromJson(model)).toList().map((e) {
        clientlist.add(e.name!);
      }).toList();
    });
  }

  TextEditingController nomController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController qttController = TextEditingController();
  TextEditingController clientnameController = TextEditingController();

  String? dropdownValue;
  int idp = 0;
  @override
  void initState() {
    _getclient();
    idp = widget.produitpass!.id;
    nomController.text = widget.produitpass!.nom_produit!;
    codeController.text = widget.produitpass!.code_produit!;
    dateController.text = widget.produitpass!.created_at!;
    qttController.text = widget.produitpass!.quantite_res.toString();
    clientnameController.text = widget.clientname!;

    super.initState();
  }

  final _infosave = {
    'client_id': '',
    'nom_produit': '',
    'code_produit': '',
    'quantite_res': '',
  };

  final GlobalKey<FormState> _clientform = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Le Produit'),
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
              _submit(context, idp);
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
                    "Modifier",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                    child: TextFormField(
                      controller: nomController,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: TextFormField(
                      readOnly: true,
                      onSaved: (val) {
                        _infosave['client_id'] =
                            widget.produitpass!.client_id.toString();
                      },
                      controller: clientnameController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Nom Du Client ',
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: TextField(
                      readOnly: true,
                      controller: dateController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Date De Creation',
                          style: TextStyle(fontSize: 20),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: TextFormField(
                      controller: qttController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'can not be empty';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['quantite_res'] = val!;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text(
                          'Quantité Restante',
                          style: TextStyle(fontSize: 20),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
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

  void _submit(BuildContext ctx, int idproduit) {
    if (_clientform.currentState!.validate()) {
      _clientform.currentState!.save();

      Produits().updateProduit(_infosave, ctx, idproduit, 0);
    }
  }
}
