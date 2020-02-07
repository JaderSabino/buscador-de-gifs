import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String _seach;

  int _offSet;

  Future<Map> getGifs() async {
    http.Response response;

    if (_seach == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=NrGQ1XbxeJrLb8VSmLbMcB4vhbRlb92m&limit=20&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=NrGQ1XbxeJrLb8VSmLbMcB4vhbRlb92m&q=$_seach=25&offset=$_offSet&rating=G&lang=en");

    return json.decode(response.body);
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Quantidade de imagens por linha
          crossAxisSpacing: 10, //espaçamento entre as linhas
          mainAxisSpacing: 10 //espaçamento entre as colunas
          ),
      itemCount: 20, //Quantidade de quadros na tela
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Theme(
            data: ThemeData(
                hintColor: Colors.white,
                inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
            child: Padding(
              padding: EdgeInsets.all(10), 
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise aqui",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18),
                onSubmitted: (text) {
                  setState(() {
                    _seach = text;
                  });
                },
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: getGifs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      //adicionar a animação de uma circulo de carregamento ao iniciar o aplicativo
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5,
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _createGifTable(context, snapshot);
              }
            },
          ))
        ],
      ),
    );
  }
}
