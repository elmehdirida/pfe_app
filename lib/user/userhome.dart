import 'package:app/user/screen/commandescreen.dart';
import 'package:app/user/screen/homescreen.dart';
import 'package:app/user/screen/produitscreen.dart';
import 'package:app/user/screen/retourscreen.dart';
import 'package:app/user/screen/sortiescreen.dart';
import 'package:app/user/screen/stockscreen.dart';
import 'package:app/user/servives/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../route.dart';

class Userhome extends StatefulWidget {
  const Userhome({Key? key}) : super(key: key);

  @override
  State<Userhome> createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> {
  int _selectedIndex = 0;
  String _title = 'Home';
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Produitscreen(),
    CommandeScreen(),
    StockScreen(),
    SortieScreen(),
    RetourScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _title = 'DashBoard';
      } else if (index == 1) {
        _title = 'Mes Produits';
      } else if (index == 2) {
        _title = 'Mes Commandes';
      } else if (index == 3) {
        _title = 'Mes Stocks';
      } else if (index == 4) {
        _title = 'Mes Sorties';
      } else if (index == 5) {
        _title = 'Mes Retours';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                ),
              )),
        ],
        leading: IconButton(
            onPressed: () {
              try {
                var key = Provider.of<Auth>(context, listen: false).token;
                Provider.of<Auth>(context, listen: false).logout(key);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const route()));
              } catch (e) {
                Provider.of<Auth>(context, listen: false).autologout();
                Provider.of<Auth>(context, listen: false).destroytoken();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const route()));
              }
            },
            icon: const Icon(Icons.logout)),
        centerTitle: true,
        title: Text(_title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 255, 145, 0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Produit',
            backgroundColor: Color.fromARGB(255, 45, 92, 179),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cabin),
            label: 'Stock ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.next_plan),
            label: 'Sortie ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.undo),
            label: 'Retour ',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
