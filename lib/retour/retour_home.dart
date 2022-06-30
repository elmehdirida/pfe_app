import 'package:app/retour/retour_.dart';
import 'package:app/retour/retour__new.dart';
import 'package:app/retour/retour_hestorie.dart';
import 'package:app/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../Client/client.dart';
import '../Client/search_client.dart';

class RetourHome extends StatefulWidget {
  const RetourHome({Key? key}) : super(key: key);

  @override
  State<RetourHome> createState() => _RetourHomeState();
}

class _RetourHomeState extends State<RetourHome> {
  Map<String, String> newhist = {
    'ref': '',
    'retour_ref': '',
    'name_societe': '',
  };
  bool isloading = true;
  var retourlist = <Retour>[];
  var retourhistlist = <Retourhist>[];
  var retourhistlist2 = <Retourhist>[];

  var clientlist = <Client>[];

  @override
  void initState() {
    _getclient();
    _getsretourhist2();

    _getretour();
    super.initState();
  }

  _getsretourhist(ref) async {
    Iterable list = (await Retourhists().getRetourhist(ref)) as Iterable;
    if (!mounted) return;
    setState(() {
      retourhistlist = list.map((model) => Retourhist.fromJson(model)).toList();
    });
  }

  _getsretourhist2() async {
    Iterable list = (await Retourhists().getRetourhisto()) as Iterable;
    if (!mounted) return;
    setState(() {
      retourhistlist2 =
          list.map((model) => Retourhist.fromJson(model)).toList();
    });
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    if (!mounted) return;

    setState(() {
      clientlist = list.map((model) => Client.fromJson(model)).toList();
    });
  }

  _getretour() async {
    Iterable list = (await Retours().getRetour()) as Iterable;
    if (!mounted) return;

    setState(() {
      retourlist = list.map((model) => Retour.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? clientname = "";

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Gérer Le Retour"),
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
                  .push(MaterialPageRoute(builder: (_) => const RetourNew())),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (retourlist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: retourlist.map((retour) {
                    clientlist.map((client) {
                      if (retour.client_id == client.id) {
                        clientname = client.name;
                      }
                    }).toList();
                    return newcard(
                        context,
                        clientname,
                        retour.client_id,
                        retour.created_at,
                        retour.id,
                        retour.name_societe,
                        retour.ref_retour);
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
    BuildContext context,
    clientname,
    clientId,
    createdAt,
    idr,
    nameSociete,
    refRetour,
  ) {
    final double w = MediaQuery.of(context).size.width;

    int nbr = 0;
    nbr = retourhistlist2
        .where((element) => element.retour_ref == refRetour)
        .toList()
        .length;
    return GFCard(
      color: const Color.fromARGB(79, 159, 137, 137),
      buttonBar: GFButtonBar(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Text(refRetour, style: const TextStyle(fontSize: 13)),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Nbr : $nbr",
                    ),
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
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      DateFormat("yyyy-MM-ddTHH:mm:ss")
                          .parse(createdAt)
                          .toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _getsretourhist(refRetour);
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
                                            width: w * .2,
                                            child: const Text('ref retour'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .4,
                                            child: const Text('date'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .30,
                                            child: const Text('delete'),
                                          ),
                                        ),
                                      ],
                                      rows: retourhistlist
                                          .where((element) =>
                                              element.retour_ref == refRetour)
                                          .map((retour) {
                                        return DataRow(
                                            cells: newrow2(retour.created_at,
                                                retour.id, retour.ref));
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
                                            child: const Text('exit'),
                                            onPressed: () {
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
                                          child: const Text('Add'),
                                          onPressed: () {
                                            newhist = {};
                                            newhist['retour_ref'] = refRetour;
                                            newhist['name_societe'] =
                                                nameSociete;
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Entré le reférence '),
                                                    content: TextField(
                                                      onChanged: (value) {
                                                        newhist['ref'] = value;
                                                      },
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'annuler')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (newhist[
                                                                    'ref'] !=
                                                                '') {
                                                              await Retourhists()
                                                                  .addretourhestorie(
                                                                      newhist);
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              const RetourHome()));
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Ajouter'))
                                                    ],
                                                  );
                                                });
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
                        await _getsretourhist(refRetour);
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
                                            width: w * .4,
                                            child: const Text('Code a barre'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: w * .6,
                                            child: const Text('date'),
                                          ),
                                        ),
                                      ],
                                      rows: retourhistlist
                                          .where((element) =>
                                              element.retour_ref == refRetour)
                                          .map((retour) {
                                        return DataRow(
                                            cells: newrow(retour.id, retour.ref,
                                                retour.created_at));
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

  List<DataCell> newrow(id, ref, date) {
    return [
      DataCell(Text(ref)),
      DataCell(Text(
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date).toString(),
      )),
    ];
  }

  List<DataCell> newrow2(date, id, ref) {
    return [
      DataCell(
        Text(
          ref,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      DataCell(Text(
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date).toString(),
        style: const TextStyle(fontSize: 11),
      )),
      DataCell(
        IconButton(
            onPressed: () async {
              await Retourhists().deleterethust(context, id);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RetourHome()));
            },
            icon: const Icon(Icons.delete_forever)),
      )
    ];
  }
}
