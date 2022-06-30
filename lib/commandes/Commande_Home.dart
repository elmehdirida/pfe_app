import 'package:app/commandes/commande.dart';
import 'package:app/commandes/search_commande.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:getwidget/getwidget.dart';
import '../Client/client.dart';
import '../navigation_drawer_widget.dart';

class CommandeHome extends StatefulWidget {
  const CommandeHome({Key? key}) : super(key: key);

  @override
  State<CommandeHome> createState() => _CommandeHomeState();
}

class _CommandeHomeState extends State<CommandeHome> {
  bool isloading = true;
  var commandelist = <Commande>[];
  List clientlist = [];

  @override
  void initState() {
    _getcommande();
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

  _getcommande() async {
    Iterable list = (await Commandes().getCommande()) as Iterable;
    if (!mounted) return;

    setState(() {
      commandelist = list.map((model) => Commande.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? clientname = "";

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Gérer Les commandes"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'search',
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SearchCommande())),
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (commandelist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: commandelist.map((commande) {
                    clientlist.map((client) {
                      if (commande.client_id == client.id) {
                        clientname = client.name;
                      }
                    }).toList();
                    return newCard(
                        context,
                        commande.client_id,
                        commande.commentaire,
                        commande.created_at,
                        commande.etat,
                        commande.name,
                        commande.id,
                        clientname);
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

GFCard newCard(ctx, idcl, com, date, etat, name, idcom, clientname) {
  final _infosave = {
    'etat': '',
  };
  _updateetat(data, ctx, idcom) async {
    await Commandes().updateCommande(data, ctx, idcom);
  }

  bool statut = etat == 0 ? false : true;
  statut = statut;
  return GFCard(
    color: const Color.fromARGB(79, 159, 137, 137),
    buttonBar: GFButtonBar(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(name, style: const TextStyle(fontSize: 15)),
              ],
            ),
            Column(
              children: <Widget>[
                FlutterSwitch(
                  value: statut,
                  onToggle: (val) {
                    showDialog(
                        context: ctx,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text('Please Confirm'),
                            content: const Text(
                                'Vous avez sur La commande est traité?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _infosave['etat'] = val == true ? '1' : '0';
                                    _updateetat(_infosave, ctx, idcom);

                                    statut = !statut;

                                    Navigator.of(ctx).push(MaterialPageRoute(
                                        builder: (_) => const CommandeHome()));
                                  },
                                  child: const Text('Oui')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Non'))
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientname,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: ctx,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Please Confirm'),
                              content: const Text(
                                  'Vous avez sur de supprimer la commande?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Commandes().deleteCommande(ctx, idcom);
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
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                  ),
                  IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: ctx,
                        dialogType: DialogType.INFO,
                        title: 'Message du Client',
                        desc: com,
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.done,
                      ).show();
                    },
                    icon: const Icon(Icons.message),
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
