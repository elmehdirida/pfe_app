// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app/Client/client.dart';
import 'package:provider/provider.dart';
import '../Client/search_client.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../user/servives/auth.dart';
import 'client_info.dart';
import 'client.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isloading = true;
  var clientlist = <Client>[];
  @override
  void initState() {
    _getclient();
    super.initState();
  }

  _getclient() async {
    Iterable list = (await Clients().getAllClient()) as Iterable;
    clientlist = list.map((model) => Client.fromJson(model)).toList();
    if (!mounted) return;

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton.extended(
              heroTag: 'search',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              label: const Text('Search'),
              icon: const Icon(Icons.search),
            ),
            FloatingActionButton.extended(
              heroTag: 'add',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ClientInfo())),
              label: const Text('Add'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : (clientlist.isNotEmpty
                ? ListView(
                    controller: ScrollController(),
                    children: clientlist.map((client) {
                      return NewCard(context, client, client.name,
                          client.contact, client.adresse);
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
                  )));
  }
}

GFCard NewCard(BuildContext context, Client client, String? name,
    String? contact, String? adresse) {
  return GFCard(
    elevation: 20,
    color: const Color.fromARGB(79, 159, 137, 137),
    buttonBar: GFButtonBar(
      children: <Widget>[
        Row(
          children: [
            Flexible(
              child: Text(name!, style: const TextStyle(fontSize: 13)),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromARGB(77, 28, 26, 26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ClientInfo(
                                  clientpass: client,
                                ))),
                    icon: const Icon(
                      Icons.more_horiz_sharp,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Details',
                      style: TextStyle(color: Colors.black),
                    ),
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
                    contact!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_city,
                      color: Colors.black,
                    ),
                    label: Text(
                      adresse!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
