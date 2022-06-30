import 'dart:convert';

import 'package:app/Client/client.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  int role = 0;
  late String _token;
  late Client _client;
  late List<Client> list;
  late User _user;
  final storage = const FlutterSecureStorage();

  bool _isIoggedIn = false;
  bool get authenticated => _isIoggedIn;
  User get user => _user;
  Client get client => _client;
  String get token => _token;

  Future logout(token) async {
    _isIoggedIn = false;

    var response;

    String baseUrl = 'http://127.0.0.1:8000/api/logout';
    try {
      response = await http.delete(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }).then((value) {
        return value;
      });
    } catch (e) {
      //
    }
    destroytoken();
    notifyListeners();
  }

  login(data, ctx) async {
    var response;

    String baseUrl = 'http://127.0.0.1:8000/api/login';
    try {
      response = await http
          .post(Uri.parse(baseUrl),
              headers: {'Accept': 'application/json'}, body: data)
          .then((value) {
        return value;
      });
      if (response.statusCode == 201) {
        _token = json.decode(response.body)['token'];
        await attempt(_token);
        await storetoken(_token);

        _isIoggedIn = true;
      } else if (response.statusCode == 401) {
        AwesomeDialog(
                context: ctx,
                dialogType: DialogType.ERROR,
                title: 'Email or Password not match with our records',
                btnOkOnPress: () {},
                btnOkIcon: Icons.done,
                btnOkColor: Colors.red)
            .show();
      }
      notifyListeners();
    } catch (e) {
      AwesomeDialog(
              context: ctx,
              dialogType: DialogType.ERROR,
              title: e.toString(),
              btnOkOnPress: () {},
              btnOkIcon: Icons.done,
              btnOkColor: Colors.red)
          .show();
    }
  }

  Future attempt(String token) async {
    var response;

    String baseUrl = 'http://127.0.0.1:8000/api/user';
    try {
      await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }).then((value) {
        response = value.body;
        _user = User.fromJson(json.decode(response.toString()));
        role = _user.type!;

        return value;
      });
      await getid(token, _user.email!);
      _isIoggedIn = true;
      notifyListeners();
    } catch (e) {
      _isIoggedIn = false;
      notifyListeners();
    }
  }

  Future getid(String token, String email) async {
    var x;
    var res;
    String baseUrl = 'http://127.0.0.1:8000/api/id/$email';
    try {
      await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }).then((value) {
        res = value.body;
        _client = Client.fromJson(json.decode(res.toString())[0]);
        notifyListeners();
        return value;
      });
    } catch (e) {
      //
    }
  }

  storetoken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  destroytoken() async {
    await storage.delete(key: 'auth');
  }

  autologout() {
    _isIoggedIn = false;
  }
}
