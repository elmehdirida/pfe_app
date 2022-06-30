import 'package:app/Client/att.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../home_start.dart';

class atts extends StatefulWidget {
  const atts({Key? key}) : super(key: key);

  @override
  State<atts> createState() => _attsState();
}

class _attsState extends State<atts> {
  bool isloading = true;
  var clienatt = <Att>[];
  @override
  void initState() {
    _getatt();
    super.initState();
  }

  _getatt() async {
    Iterable list = (await Atts().getAtt()) as Iterable;
    clienatt = list.map((model) => Att.fromJson(model)).toList();
    if (!mounted) return;

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : (clienatt.isNotEmpty
                ? ListView(
                    controller: ScrollController(),
                    children: clienatt.map((client) {
                      return NewCard(context, client.id, client.contact,
                          client.Email, client.password, client.UserName);
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

GFCard NewCard(BuildContext context, id, contact, email, pass, name) {
  return GFCard(
    elevation: 20,
    color: const Color.fromARGB(79, 159, 137, 137),
    buttonBar: GFButtonBar(
      children: <Widget>[
        Row(
          children: [
            Flexible(
              child: Text('Nom   : ${name!}',
                  style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text('contact   : ${contact!}',
                  style: const TextStyle(fontSize: 13)),
            ),
            IconButton(
              onPressed: () async {
                await Atts().deleteAtt(context, id);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeStart()));
              },
              icon: const Icon(Icons.delete_forever),
              color: Colors.red,
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text('Email  : ${email!}',
                  style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ],
    ),
  );
}
