// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/stock/stock_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Stockhist {
  int id;
  int? stock_id;
  String? produit_name;
  String? produit_code;
  int? produit_id;
  int? produit_entrer;

  Stockhist(
    this.id,
    this.stock_id,
    this.produit_name,
    this.produit_code,
    this.produit_id,
    this.produit_entrer,
  );
  Stockhist.fromJson(Map json)
      : id = json['id'],
        stock_id = json['stock_id'],
        produit_name = json['produit_name'],
        produit_id = json['produit_id'],
        produit_code = json['produit_code'],
        produit_entrer = json['produit_entrer'];
}

class Stockshists {
  Future<List?> getStockhist(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/stockhestorie/$id';
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

  addStockhist(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/stockhestorie';
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
          title: 'Stock allready existe',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show();
      }
    } catch (e) {
      return e;
    }
  }

  updateStock(data, ctx, idStock) async {
    var idp = idStock;
    String baseUrl = 'http://127.0.0.1:8000/api/stockhestorie/$idp';
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
          title: 'Stock Updated with  Succed',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const StockHome())));
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

  deleteStock(ctx, idStock) async {
    int idp = idStock;
    String baseUrl = 'http://127.0.0.1:8000/api/stockhestorie/$idp';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'Stock supprimer Avec  Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const StockHome())));
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
