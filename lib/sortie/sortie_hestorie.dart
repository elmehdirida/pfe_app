// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:app/sortie/sortie_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sortiehist {
  int id;
  int? sortie_id;
  String? produit_name;
  String? produit_code;
  int? produit_id;
  int? produit_entrer;

  Sortiehist(
    this.id,
    this.sortie_id,
    this.produit_name,
    this.produit_code,
    this.produit_id,
    this.produit_entrer,
  );
  Sortiehist.fromJson(Map json)
      : id = json['id'],
        sortie_id = json['sortie_id'],
        produit_name = json['produit_name'],
        produit_id = json['produit_id'],
        produit_code = json['produit_code'],
        produit_entrer = json['produit_entrer'];
}

class Sortieshists {
  Future<List?> sortiehist(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/sortiehestorie/$id';
    try {
      http.Response response = await http.get(Uri.parse(baseUrl));
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

  addSortiehist(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/sortiehestorie';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value.statusCode;
      });
      if (code == 422) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.ERROR,
          title: 'sortie allready existe',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show();
      }
    } catch (e) {
      return e;
    }
  }

  updateSortie(data, ctx, idSortie) async {
    var ids = idSortie;
    String baseUrl = 'http://127.0.0.1:8000/api/sortiehestorie/$ids';
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

  deleteSortie(ctx, idsortie) async {
    int ids = idsortie;
    String baseUrl = 'http://127.0.0.1:8000/api/Stock/$ids';
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
