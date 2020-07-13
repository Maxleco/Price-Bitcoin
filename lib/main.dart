import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preço do Bitcoin',
      debugShowCheckedModeBanner: false,
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _search = false;

  Future<String> _updateValueBitcoin() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> results = json.decode(response.body);
      return results["BRL"]["buy"].toString();
    } else {
      return null;
    }
  }

  Widget _textPrice(String value) {
    return Text(
      "R\$ " + value,
      style: TextStyle(
        color: Colors.black.withOpacity(0.75),
        fontSize: 36,
        fontFamily: "Courier New",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset("images/bitcoin.png"),
              ),
              FutureBuilder<String>(
                  initialData: "0",
                  future: _search == true ? _updateValueBitcoin() : null,
                  builder: (context, snapshot) {
                    Widget result;

                    if (snapshot.connectionState == ConnectionState.done) {                      
                      if(snapshot.hasData){
                        result = _textPrice(snapshot.data);
                      }
                      else if(snapshot.hasError){
                        result = Text("ERRO AO CARREGAR OS DADOS");
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      result = CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      );

                    } else {
                      result = _textPrice("0");
                    }

                    return result;
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        _search = true;
                      });
                    },
                    color: Colors.orange,
                    child: Text(
                      "Atualizar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
