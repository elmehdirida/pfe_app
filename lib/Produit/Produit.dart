// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/Produit/produit_home.dart';
import 'package:app/sortie/sortie_home.dart';
import 'package:app/stock/stock_home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Produit {
  int id;
  int? client_id;
  String? nom_produit;
  String? code_produit;
  int? quantite_res;
  String? created_at;

  Produit(
    this.id,
    this.client_id,
    this.nom_produit,
    this.code_produit,
    this.quantite_res,
    this.created_at,
  );
  Produit.fromJson(Map json)
      : id = json['id'],
        client_id = json['client_id'],
        nom_produit = json['nom_produit'],
        code_produit = json['code_produit'],
        quantite_res = json['quantite_res'],
        created_at = json['created_at'];
}

class Produits {
  Future<List?> getProduit() async {
    String baseUrl = 'http://127.0.0.1:8000/api/produit';
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

  Future<List?> userproduit(id) async {
    String baseUrl = 'http://127.0.0.1:8000/api/user/produits/$id';
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

  addProduit(data, ctx) async {
    String baseUrl = 'http://127.0.0.1:8000/api/produit';
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
          title: 'Produit Ajouter Avec Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProduitHome())));
      } else if (code == 422) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.ERROR,
          title: 'Produit allready existe',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show();
      }
    } catch (e) {
      return e;
    }
  }

  updateProduit(data, ctx, idproduit, where) async {
    var idp = idproduit;
    print(data);
    String baseUrl = 'http://127.0.0.1:8000/api/produit/$idp';
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
          title: 'Produit Updated with  Succed',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) {
          if (where == 0) {
            Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProduitHome()));
          } else if (where == 1) {
            Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const StockHome()));
          } else {
            Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const SortieHome()));
          }

          return null;
        });
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

  deleteProduit(ctx, idproduit) async {
    var idp = idproduit;
    String baseUrl = 'http://127.0.0.1:8000/api/produit/$idp';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        return value.statusCode;
      });
      if (code == 200) {
        AwesomeDialog(
          context: ctx,
          dialogType: DialogType.SUCCES,
          title: 'Produit supprimer Avec  Succes',
          btnOkOnPress: () {},
          btnOkIcon: Icons.done,
        ).show().then((value) => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProduitHome())));
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
