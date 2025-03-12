import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/env.dart';

import 'package:crypto_tracker/models/coin_details.dart';
import 'package:crypto_tracker/widgets/styled_detail_row.dart';

class DetailScreen extends StatefulWidget {
  final String coinId;

  const DetailScreen({super.key, required this.coinId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  CoinDetails? coinData;
  bool isLoading = true;

  @override
  void initState() {
    //get coin data by coinId
    getCoinDetails();
    super.initState();
  }

  void getCoinDetails() async {
    var url = Uri.https(Env.baseUrl, '/api/v3/coins/${widget.coinId}');

    var headers = {
      'Accept': 'application/json',
      'X-Cg-Demo-Api-Key': Env.apiKey,
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        setState(() {
          coinData = CoinDetails.fromJson(jsonResponse);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load coin details: ${response.statusCode}');
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
        title: Text(
          coinData == null
              ? "Loading..."
              : "${coinData!.name} (${coinData!.symbol.toUpperCase()})",
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : coinData == null
              ? const Center(child: Text("Failed to load data"))
              : Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Image.network(coinData!.imageUrl, width: 150, height: 150),
                    const SizedBox(height: 20),

                    const Divider(thickness: 1),
                    //Custom widgets for the details of the coin
                    StyledDetailRow(
                      "Price:",
                      "€${coinData!.currentPrice.toStringAsFixed(2)}",
                    ),
                    StyledDetailRow(
                      "24h Change:",
                      "${coinData!.priceChangePercentage24h.toStringAsFixed(2)}%",
                    ),
                    StyledDetailRow(
                      "Market Cap:",
                      "€${coinData!.marketCap.toStringAsFixed(0)}",
                    ),
                    StyledDetailRow(
                      "24h Volume:",
                      "€${coinData!.totalVolume.toStringAsFixed(0)}",
                    ),
                    StyledDetailRow(
                      "High (24h):",
                      "€${coinData!.high24h.toStringAsFixed(2)}",
                    ),
                    StyledDetailRow(
                      "Low (24h):",
                      "€${coinData!.low24h.toStringAsFixed(2)}",
                    ),
                    StyledDetailRow(
                      "Circulating Supply:",
                      coinData!.circulatingSupply.toStringAsFixed(0),
                    ),
                  ],
                ),
              ),
    );
  }
}
