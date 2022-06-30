import 'package:app/Produit/Produit.dart';
import 'package:app/Produit/produit_new.dart';
import 'package:app/user/servives/auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import '../Client/search_client.dart';
import '../Client/client.dart';
import '../navigation_drawer_widget.dart';
import 'produit_update.dart';

class ProduitHome extends StatefulWidget {
  const ProduitHome({Key? key}) : super(key: key);

  @override
  State<ProduitHome> createState() => _ProduitHomeState();
}

class _ProduitHomeState extends State<ProduitHome> {
  bool isloading = true;
  var produitlist = <Produit>[];
  var clientlist = <Client>[];
  @override
  void initState() {
    _getproduitt();
    _getclient();
    super.initState();
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    if (!mounted) return;
    setState(() {
      clientlist = list.map((model) => Client.fromJson(model)).toList();
    });
  }

  _getproduitt() async {
    Iterable list = (await Produits().getProduit()) as Iterable;
    if (!mounted) return;
    setState(() {
      produitlist = list.map((model) => Produit.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? clientname = "";
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Gérer Les Produits"),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              heroTag: 'search',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              child: const Icon(Icons.search),
            ),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ProduitNew())),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (produitlist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: produitlist.map((produit) {
                    clientlist.map((client) {
                      if (produit.client_id == client.id) {
                        clientname = client.name;
                      }
                    }).toList();
                    return newCard(
                        context,
                        produit,
                        clientname,
                        produit.client_id,
                        produit.code_produit,
                        produit.created_at,
                        produit.quantite_res,
                        produit.id,
                        produit.nom_produit);
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
}

GFCard newCard(
    BuildContext ctx, produit, clientname, idc, code, date, qtt, idp, nom) {
  return GFCard(
    elevation: 20,
    color: const Color.fromARGB(79, 159, 137, 137),
    buttonBar: GFButtonBar(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Text(nom, style: const TextStyle(fontSize: 13)),
            ),
            Expanded(
              child: Text(code, style: const TextStyle(fontSize: 13)),
            ),
            Expanded(
              child: Text("QR : $qtt", style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientname,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: ctx,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Please Confirm'),
                              content: const Text(
                                  'Vous avez sur de supprimer le produit?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Produits().deleteProduit(ctx, idp);
                                    },
                                    child: const Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('No'))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (_) => ProduitUpdate(
                              produitpass: produit,
                              clientname: clientname,
                            ))),
                    icon: const Icon(Icons.edit),
                    color: Colors.green,
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
