import 'package:flutter/material.dart';
import 'package:sive/ProductsPageState.dart';
import 'package:flutter/material.dart';
import 'package:sive/SiveApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductsPage.dart';

class SiveApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProductsPageState();
  }
}

class ProductCell extends StatelessWidget {
  final product;

  ProductCell(this.product);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Image.network(product["imageUrl"]),
              new Container(
                height: 8.0,
              ),
              new Text(
                product["name"] +
                    " R\$ " +
                    product["price"].toString(),
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        new Divider()
      ],
    );
  }

}

class ProductsPageState extends State<SiveApp> {

  var _isLoading = true;
  List<DocumentSnapshot> _documents;

  ProductsPageState() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp( home: new Scaffold(
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('Menino do Chocolate'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/kyte-7c484.appspot.com/o/itoBeSVA9gWot9%2F337694F7-9DEC-469C-8645-26CEAAD91085.jpg?alt=media&token=11abf66c-dbff-4f6a-85b8-22f822e0ff9b'),
              ),
              accountEmail: null,
            ),
            new ListTile(
              title: new Text('Produtos'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => null));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Sive APP"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add_circle_outline),
              onPressed: () {
                _duplicateData();
              }),
          new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _fetchData();
              })
        ],
      ),
      body: new Center(
        child: _isLoading
            ? new CircularProgressIndicator()
            : new ListView.builder(
            itemCount: _documents != null ? _documents.length : 0,
            itemBuilder: (context, i) {
              final product = _documents[i].data;
              return new ProductCell(product);
            }),
      ),
    ),
    );
  }

  void _fetchData() async {
    final databaseReference = Firestore.instance;

    await databaseReference
        .collection("products")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      _documents = snapshot.documents;
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _duplicateData() {
    final databaseReference = Firestore.instance;

    databaseReference.collection("products").add(_documents.first.data);
  }

}
