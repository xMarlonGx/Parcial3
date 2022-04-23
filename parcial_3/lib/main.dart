import 'dart:convert';

import 'models/Elementos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  runApp(MyParcial3());
}

class MyParcial3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parcial3",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late Future<List<Elementos>> _listadoElementos;

  List<Elementos> lista = [];

  Future<List<Elementos>> _getElementos() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        lista.add(Elementos(item["albumId"], item["id"], item["title"],
            item["url"], item["thumbnailUrl"]));
      }

      return lista;
    } else {
      throw Exception("Error de conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoElementos = _getElementos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parcial 3"),
      ),
      body: Boby(),
    );
  }

  Widget Boby() {
    return FutureBuilder(
        future: _listadoElementos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _listadoElemento(snapshot.data),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  List<Widget> _listadoElemento(data) {
    List<Widget> listado = [];

    for (var list in data) {
      listado.add(
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(list.albumId.toString())),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(list.title.toString())),
              ),
              Image.network(list.url.toString())
            ],
          ),
        ),
      );
    }

    return listado;
  }
}
