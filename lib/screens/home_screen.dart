import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/env.dart';

import 'package:crypto_tracker/models/coins.dart';
import 'package:crypto_tracker/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Coin> coins = [];
  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var url = Uri.https(Env.baseUrl, '/api/v3/coins/markets', {
      'vs_currency': 'eur',
    });

    var headers = {
      'Accept': 'application/json',
      'X-Cg-Demo-Api-Key': Env.apiKey,
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = convert.jsonDecode(response.body);

        setState(() {
          coins = jsonResponse.map((data) => Coin.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tracker'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: coins.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final coin = coins[index];
                  return ListTile(
                    leading: Image.network(coin.imageUrl, width: 40),
                    title: Text(
                      coin.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(coin.symbol),
                    trailing: Text(
                      '€ ${coin.priceEur.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailScreen(coinId: coin.id);
                          },
                        ),
                      );

                      getData();
                    },
                  );
                },
              ),
    );
  }
}
