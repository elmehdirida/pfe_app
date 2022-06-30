import 'dart:convert';

import 'package:app/stock/stock_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Stock {
  int id;
  int? client_id;
  String? ref_stock;
  int? type_stock;
  String? created_at;

  Stock(
    this.id,
    this.client_id,
    this.ref_stock,
    this.type_stock,
    this.created_at,
  );
  Stock.fromJson(Map json)
      : id = json['id'],
        client_id = json['client_id'],
        ref_stock = json['ref_stock'],
        type_stock = json['type_stock'],
        created_at = json['created_at'];
}

class Stocks {
  Future<List?> getStock() async {
    String baseUrl = 'http://127.0.0.1:8000/api/stock';
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

  Future<List?> getStockBId(id) async {
    print(id);
    String baseUrl = 'http://127.0.0.1:8000/api/stock/$id';
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

  Future addStock(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/stock';

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
        title: 'Stock Ajouter Avec Succes',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show().then((value) => Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (_) => const StockHome())));
    } else if (code.statusCode == 422) {
      AwesomeDialog(
        context: ctx,
        dialogType: DialogType.ERROR,
        title: 'Something wrong',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show();
    }
    return jsonDecode(code.body);
  }

  updateStock(data, ctx, idStock) async {
    int idp = idStock;
    String baseUrl = 'http://127.0.0.1:8000/api/stock/$idp';
    try {
      int code = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        print(value.statusCode);
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
    String baseUrl = 'http://127.0.0.1:8000/api/Stock/$idp';
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
