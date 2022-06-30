import 'package:app/Auth/login.dart';
import 'package:app/Produit/produit_home.dart';
import 'package:app/commandes/Commande_Home.dart';
import 'package:app/home_start.dart';
import 'package:app/retour/retour_home.dart';
import 'package:app/route.dart';
import 'package:app/sortie/sortie_home.dart';
import 'package:app/stock/stock_home.dart';
import 'package:app/user/servives/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final storage = const FlutterSecureStorage();

  NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
      return Material(
          color: const Color.fromRGBO(50, 75, 205, 1),
          child: ListView(
            children: <Widget>[
              Container(
                padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user.username!,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Admin',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        try {
                          var key =
                              Provider.of<Auth>(context, listen: false).token;
                          Provider.of<Auth>(context, listen: false).logout(key);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const route()));
                        } catch (e) {
                          Provider.of<Auth>(context, listen: false)
                              .autologout();
                          Provider.of<Auth>(context, listen: false)
                              .destroytoken();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const route()));
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    buildMenuItem(
                      text: 'Gérer les clients',
                      icon: Icons.people,
                      onClicked: () => selectedItem(context, 0),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Gérer les produits',
                      icon: Icons.card_travel,
                      onClicked: () => selectedItem(context, 1),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Gérer les comandes',
                      icon: Icons.assignment,
                      onClicked: () => selectedItem(context, 2),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Gérer les stocks',
                      icon: Icons.cabin,
                      onClicked: () => selectedItem(context, 3),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Gérer les sorties',
                      icon: Icons.next_plan,
                      onClicked: () => selectedItem(context, 4),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Gérer les Retours',
                      icon: Icons.undo,
                      onClicked: () => selectedItem(context, 5),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeStart(),
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ProduitHome(),
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const CommandeHome(),
        ));
        break;
      case 3:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StockHome(),
        ));
        break;
      case 4:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SortieHome(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const RetourHome(),
        ));
        break;
    }
  }
}
