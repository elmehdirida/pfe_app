import 'package:app/commandes/commande.dart';
import 'package:app/commandes/search_commande.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import '../servives/auth.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({Key? key}) : super(key: key);

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  bool isloading = true;
  var commandelist = <Commande>[];
  List clientlist = [];
  var id;

  @override
  void initState() {
    id = Provider.of<Auth>(context, listen: false).client.id;

    _getcommande();
    super.initState();
  }

  _getcommande() async {
    Iterable list = (await Commandes().usercommande(id)) as Iterable;
    if (!mounted) return;
    setState(() {
      commandelist = list.map((model) => Commande.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add',
        onPressed: () {},
        label: const Text('Ajouer'),
        icon: const Icon(Icons.add),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (commandelist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: commandelist.map((commande) {
                    return newCard(
                      context,
                      commande.client_id,
                      commande.commentaire,
                      commande.created_at,
                      commande.etat,
                      commande.name,
                      commande.id,
                    );
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

GFCard newCard(ctx, idcl, com, date, etat, name, idcom) {
  _updateetat(data, ctx, idcom) async {
    await Commandes().updateCommande(data, ctx, idcom);
  }

  bool statut = etat == 0 ? false : true;
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
                  onToggle: (val) {},
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
