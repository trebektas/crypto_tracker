class CoinDetails {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double circulatingSupply;

  const CoinDetails({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
  });

  factory CoinDetails.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'symbol': String symbol,
        'image': {'large': String imageUrl},
        'market_data': {
          'current_price': {'eur': num currentPrice},
          'price_change_percentage_24h': num priceChangePercentage24h,
          'market_cap': {'eur': num marketCap},
          'total_volume': {'eur': num totalVolume},
          'high_24h': {'eur': num high24h},
          'low_24h': {'eur': num low24h},
          'circulating_supply': num circulatingSupply,
        },
      } =>
        CoinDetails(
          id: id,
          name: name,
          symbol: symbol.toUpperCase(),
          imageUrl: imageUrl,
          currentPrice: currentPrice.toDouble(),
          priceChangePercentage24h: priceChangePercentage24h.toDouble(),
          marketCap: marketCap.toDouble(),
          totalVolume: totalVolume.toDouble(),
          high24h: high24h.toDouble(),
          low24h: low24h.toDouble(),
          circulatingSupply: circulatingSupply.toDouble(),
        ),
      _ => throw const FormatException('Failed to load CoinDetails data.'),
    };
  }
}
