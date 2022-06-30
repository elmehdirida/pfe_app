// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:app/commandes/Commande_Home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Commande {
  int id;
  int? client_id;
  String? name;
  String? file;
  String? commentaire;
  int? etat;
  String? created_at;
  String? updated_at;
  Commande(
    this.id,
    this.client_id,
    this.name,
    this.file,
    this.commentaire,
    this.etat,
    this.created_at,
    this.updated_at,
  );

  Commande.fromJson(Map json)
      : id = json['id'],
        client_id = json['client_id'],
        name = json['name'],
        file = json['file'],
        commentaire = json['commentaire'],
        etat = json['etat'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}

class Commandes {
  Future<List?> getCommande() async {
    String baseUrl = 'http://127.0.0.1:8000/api/commande';
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

  updateCommande(data, ctx, idcommande) async {
    print(data);
    int idc = idcommande;
    String baseUrl = 'http://127.0.0.1:8000/api/commande/$idc';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value.statusCode;
      });
      if (code == 500) {
        AwesomeDialog(
                context: ctx,
                dialogType: DialogType.ERROR,
                title: 'something wrong',
                btnOkOnPress: () {},
                btnOkIcon: Icons.done,
                btnOkColor: Colors.red)
            .show();
      }
    } catch (e) {
      return e;
    }
  }

  Future<List?> usercommande(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/user/commande/$id';
    try {
      http.Response response = await http.get(Uri.parse(baseUrl)).then((value) {
        return value;
      });
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

  deleteCommande(ctx, idcommande) async {
    int idc = idcommande;
    String baseUrl = 'http://127.0.0.1:8000/api/commande/$idc';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'commande supprimer Avec  Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const CommandeHome())));
      } else if (code == 500) {
        AwesomeDialog(
                context: ctx,
                dialogType: DialogType.ERROR,
                title: 'something wrong',
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
