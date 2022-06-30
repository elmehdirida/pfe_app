// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/retour/retour_home.dart';
import 'package:app/sortie/sortie_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Retour {
  int id;
  int? client_id;
  String? ref_retour;
  String? name_societe;
  String? created_at;
  Retour(
    this.id,
    this.client_id,
    this.ref_retour,
    this.name_societe,
    this.created_at,
  );

  Retour.fromJson(Map json)
      : id = json['id'],
        client_id = json['client_id'],
        ref_retour = json['ref_retour'],
        name_societe = json['name_societe'],
        created_at = json['created_at'];
}

class Retours {
  Future<List?> getRetour() async {
    String baseUrl = 'http://127.0.0.1:8000/api/retour';
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

  Future<List?> userretour(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/user/retour/$id';
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

  addRetour(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/retour';

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
        title: 'Retour Ajouter Avec Succes',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show().then((value) => Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (_) => const RetourHome())));
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

  updateRetour(data, ctx, idRetour) async {
    int idr = idRetour;
    String baseUrl = 'http://127.0.0.1:8000/api/retour/$idr';
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
          title: 'Retour Updated with  Succed',
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
}
