// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

import 'package:app/Client/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ClientInfo extends StatefulWidget {
  final Client? clientpass;

  const ClientInfo({Key? key, this.clientpass}) : super(key: key);

  @override
  State<ClientInfo> createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController iceController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String str = '';
  int idclient = 0;
  bool status1 = false;

  @override
  void initState() {
    if (widget.clientpass != null) {
      str = 'update';
      idclient = widget.clientpass!.id;
      fullnameController.text = widget.clientpass!.name!;
      storeController.text = widget.clientpass!.code!;
      usernameController.text = widget.clientpass!.username!;
      telephoneController.text = widget.clientpass!.contact!;
      emailController.text = widget.clientpass!.email!;
      if (widget.clientpass!.ice == null) {
        iceController.text = 'null';
      } else {
        iceController.text = widget.clientpass!.ice!;
      }
      adresseController.text = widget.clientpass!.adresse!;

      if (widget.clientpass!.active == 0) {
        status1 = false;
      } else if (widget.clientpass!.active == 1) {
        status1 = true;
      }
    } else {
      str = 'add';
    }

    super.initState();
  }

  final _infosave = {
    'name': '',
    'ice': '',
    'username': '',
    'Adresse': '',
    'contact': '',
    'email': '',
    'active': '0',
    'prix': '8',
    'code': '',
  };
  final _infosave2 = {
    'name': '',
    'username': '',
    'email': '',
    'type': '0',
  };
  final GlobalKey<FormState> _clientform = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information Du Client'),
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
              _submit(context, str, idclient);
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                    child: TextFormField(
                      controller: fullnameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'need valide name';
                        } else if (val.length < 3) {
                          return 'Min length is 3 characteres';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['name'] = val!;
                        _infosave2['name'] = val;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'Nom Complet',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: storeController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'need valide store';
                        } else if (val.length < 3) {
                          return 'Min length is 3 characteres';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['code'] = val!;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'Store',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: usernameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'can not be empty';
                        } else if (val.length < 3) {
                          return 'Min length is 3 characteres';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['username'] = val!;
                        _infosave2['username'] = val;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'Username',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: telephoneController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'need valide phone number';
                        } else if (val.length < 5) {
                          return 'Entre at least 5 degits';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['contact'] = val!;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        label: Text(
                          'Telephone',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: adresseController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return ' need  valide adresse';
                        } else if (val.length < 3) {
                          return 'Entre at least 3 degits';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['Adresse'] = val!;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        label: Text(
                          'Adresse',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: iceController,
                      onSaved: (val) {
                        if (val == '') {
                          _infosave['ice'] = 'no value';
                        } else {
                          _infosave['ice'] = val!;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        label: Text(
                          'Ice  (optionnel)',
                          style: TextStyle(fontSize: 13),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'can not be empty';
                        } else if (!RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(val)) {
                          return 'Invalide email';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _infosave['email'] = val!;
                        _infosave2['email'] = val;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'Email',
                          style: TextStyle(fontSize: 13),
                        ),
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  str == 'add'
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valide password';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _infosave['password'] = val!;
                              _infosave2['password'] = val;
                            },
                            maxLines: 1,
                            decoration: const InputDecoration(
                              label: Text(
                                'password',
                                style: TextStyle(fontSize: 13),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
                    child: Row(
                      children: [
                        const Text("Statut", style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            FlutterSwitch(
                              value: status1,
                              onToggle: (val) {
                                setState(() {
                                  status1 = val;
                                  status1
                                      ? _infosave['active'] = '1'
                                      : _infosave['active'] = '0';
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext ctx, String str, int idclient) async {
    if (_clientform.currentState!.validate()) {
      _clientform.currentState!.save();
      if (str == 'add') {
        await Clients().addClient(_infosave, ctx);
        await Clients().addUser(_infosave2, ctx);
      } else if (str == 'update') {
        await Clients().updateClient(_infosave, ctx, idclient);
      }
    }
  }
}
