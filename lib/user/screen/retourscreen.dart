import 'package:app/retour/retour_.dart';
import 'package:app/retour/retour_hestorie.dart';
import 'package:app/user/servives/auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RetourScreen extends StatefulWidget {
  const RetourScreen({Key? key}) : super(key: key);

  @override
  State<RetourScreen> createState() => _RetourScreenState();
}

class _RetourScreenState extends State<RetourScreen> {
  bool isloading = true;
  var retourlist = <Retour>[];
  var retourhistlist = <Retourhist>[];
  var retourhistlist2 = <Retourhist>[];

  var id;
  @override
  void initState() {
    id = Provider.of<Auth>(context, listen: false).client.id;
    _getsretourhist2();
    _getretour();
    super.initState();
  }

  _getsretourhist(ref) async {
    Iterable list = (await Retourhists().getRetourhist(ref)) as Iterable;
    if (!mounted) return;
    setState(() {
      retourhistlist = list.map((model) => Retourhist.fromJson(model)).toList();
      isloading = false;
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

  _getretour() async {
    Iterable list = (await Retours().userretour(id)) as Iterable;
    if (!mounted) return;

    setState(() {
      retourlist = list.map((model) => Retour.fromJson(model)).toList();
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : (retourlist.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  children: retourlist.map((retour) {
                    return newcard(context, retour.client_id, retour.created_at,
                        retour.id, retour.name_societe, retour.ref_retour);
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
                      "references : $nbr",
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
}
