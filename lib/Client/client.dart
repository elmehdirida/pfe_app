import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app/home_start.dart';

class Client {
  int id;
  String? name;
  String? adresse;
  String? contact;
  String? username;
  String? email;
  int? prix;
  String? code;
  String? ice;
  int? active;

  Client(this.id, this.name, this.adresse, this.contact, this.username,
      this.email, this.active, this.code, this.ice, this.prix);
  Client.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        adresse = json['Adresse'],
        contact = json['contact'],
        username = json['username'],
        email = json['email'],
        code = json['code'],
        ice = json['ice'],
        active = json['active'],
        prix = json['prix'];
}

class User {
  int id;
  String? email;
  int? type;
  String? username;

  User(this.id, this.email, this.type, this.username);
  User.fromJson(Map json)
      : id = json['id'],
        email = json['email'],
        type = json['type'],
        username = json['username'];
}

class Clients {
  Future<List?> getAllClient() async {
    String baseUrl = 'http://127.0.0.1:8000/api/client';
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl)).then((value) => value);
      if (response.statusCode == 200) {
        var extractedData = json.decode(response.body);
        return extractedData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  addClient(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/client';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value.statusCode;
      });

      if (code == 201) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'Client Ajouter Avec Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeStart())));
      } else if (code == 422) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.ERROR,
          title: 'email allready existe',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show();
      }
    } catch (e) {
      return e;
    }
  }

  addUser(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/user';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        print(value.body);
        return value.statusCode;
      });
      if (code == 422) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.ERROR,
          title: 'email user allready existe',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show();
      }
    } catch (e) {
      return e;
    }
  }

  updateClient(data, ctx, idclient) async {
    int idc = idclient;

    String baseUrl = 'http://127.0.0.1:8000/api/client/$idc';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        print(value.body);
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'Client Updated with  Succed',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeStart())));
      } else if (code == 500) {
        AwesomeDialog(
                context: ctx,
                dialogType: DialogType.ERROR,
                title: 'email allready existe',
                btnOkOnPress: () {},
                btnOkIcon: Icons.done,
                btnOkColor: Colors.red)
            .show();
      }
    } catch (e) {
      return e;
    }
  }
}
