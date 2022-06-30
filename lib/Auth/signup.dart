import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  final _infosave = {
    'Email': '',
    'UserName': '',
    'contact': '',
  };
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: size.width * .15, vertical: 20),
              //   child: Image.network("https://warehousy.ma/images/i/logo.png"),
              // ),
              const Text(
                'Sign up',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      onSaved: (val) {
                        _infosave['Email'] = val!;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Email Adress',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) => value!.isNotEmpty
                          ? null
                          : "Please enter a valid name",
                      onSaved: (val) {
                        _infosave['UserName'] = val!;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: ' Nom complet',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isNotEmpty
                          ? null
                          : "Please enter a valid phone number",
                      maxLines: 1,
                      onSaved: (val) {
                        _infosave['contact'] = val!;
                      },
                      decoration: InputDecoration(
                        hintText: 'Telephone',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          signup(_infosave, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Vous avez déja un compte chez nous ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Authentifiez-vous'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

signup(data, ctx) async {
  print(data);
  String baseUrl = 'http://127.0.0.1:8000/api/register';
  try {
    int code = await http
        .post(Uri.parse(baseUrl),
            headers: {'Accept': 'application/json'}, body: data)
        .then((value) {
      print(value.body);
      return value.statusCode;
    });

    if (code == 201) {
      AwesomeDialog(
        context: ctx,
        dialogType: DialogType.SUCCES,
        title: 'Register Avec Succes',
        btnOkOnPress: () {},
        btnOkIcon: Icons.done,
      ).show().then((_) => Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (context) => const LoginPage())));
    } else if (code == 422) {
      AwesomeDialog(
              context: ctx,
              dialogType: DialogType.ERROR,
              title: 'email allready existe',
              btnOkOnPress: () {},
              btnOkIcon: Icons.done,
              btnOkColor: Colors.red)
          .show();
    }
  } catch (e) {
    return e;
  }
}
