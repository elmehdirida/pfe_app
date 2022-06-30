// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/sortie/sortie_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sortie {
  int id;
  int? client_id;
  String? ref_sortie;
  int? etat_bs;
  int? nbr_commande;
  int? facture_id;
  String? name_societe;
  String? created_at;
  Sortie(
    this.id,
    this.client_id,
    this.ref_sortie,
    this.etat_bs,
    this.nbr_commande,
    this.facture_id,
    this.name_societe,
    this.created_at,
  );

  Sortie.fromJson(Map json)
      : id = json['id'],
        client_id = json['client_id'],
        ref_sortie = json['ref_sortie'],
        etat_bs = json['etat_bs'],
        nbr_commande = json['nbr_commande'],
        facture_id = json['facture_id'],
        name_societe = json['name_societe'],
        created_at = json['created_at'];
}

class Sorties {
  Future<List?> getSortie() async {
    String baseUrl = 'http://127.0.0.1:8000/api/sortie';
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

  Future<List?> usersortie(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/user/sortie/$id';
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

  addSortie(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/sortie';

    var code = await http
        .post(Uri.parse(baseUrl),
            headers: {'Accept': 'application/json'}, body: data)
        .then((value) {
      return value;
    });

    if (code.statusCode == 201) {
      AwesomeDialog(
        context: ctx,
        dialogType: DialogType.SUCCES,
        title: 'Sortie Ajouter Avec Succes',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show().then((value) => Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (_) => const SortieHome())));
    } else if (code.statusCode == 422) {
      AwesomeDialog(
        context: ctx,
        dialogType: DialogType.ERROR,
        title: ' something wrong',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show();
    }
    return jsonDecode(code.body);
  }

  updateSortie(data, ctx, idStock) async {
    var idp = idStock;
    String baseUrl = 'http://127.0.0.1:8000/api/sortie/$idp';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'sortie Updated with  Succed',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((_) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const SortieHome())));
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

  deleteSortie(ctx, idStock) async {
    int idp = idStock;
    String baseUrl = 'http://127.0.0.1:8000/api/sortie/$idp';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'sortie supprimer Avec  Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const SortieHome())));
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
