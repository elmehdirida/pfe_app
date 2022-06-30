// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

class Retourhist {
  int id;
  int? retour_id;
  String? ref;
  String? retour_ref;
  String? created_at;

  Retourhist(
    this.id,
    this.retour_id,
    this.ref,
    this.retour_ref,
    this.created_at,
  );
  Retourhist.fromJson(Map json)
      : id = json['id'],
        retour_id = json['retour_id'],
        ref = json['ref'],
        retour_ref = json['retour_ref'],
        created_at = json['created_at'];
}

class Retourhists {
  Future<List?> getRetourhist(ref) async {
    String baseUrl = 'http://127.0.0.1:8000/api/retourhestorie/$ref';
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

  Future<List?> getRetourhisto() async {
    String baseUrl = 'http://127.0.0.1:8000/api/retourhestorie';
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

  addretourhestorie(data) async {
    String baseUrl = 'http://127.0.0.1:8000/api/retourhestorie';
    try {
      await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value.statusCode;
      });
    } catch (e) {
      return e;
    }
  }

  deleterethust(ctx, idret) async {
    int ids = idret;
    String baseUrl = 'http://127.0.0.1:8000/api/retourhestorie/$ids';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        return value.statusCode;
      });
    } catch (e) {
      return e;
    }
  }
}
