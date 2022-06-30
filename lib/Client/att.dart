import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app/home_start.dart';

class Att {
  int id;
  String? UserName;
  String? contact;
  String? Email;
  String? password;
  Att(
    this.id,
    this.UserName,
    this.contact,
    this.Email,
    this.password,
  );

  Att.fromJson(Map json)
      : id = json['id'],
        UserName = json['UserName'],
        contact = json['contact'],
        Email = json['Email'],
        password = json['password'];
}

class Atts {
  Future<List?> getAtt() async {
    String baseUrl = 'http://127.0.0.1:8000/api/att';
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

  deleteAtt(ctx, id) async {
    var ida = id;
    String baseUrl = 'http://127.0.0.1:8000/api/att/$ida';
    try {
      int code = await http.delete(Uri.parse(baseUrl),
          headers: {'Accept': 'application/json'}).then((value) {
        print(value.body);
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
}
