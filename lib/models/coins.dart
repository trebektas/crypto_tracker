class Coin {
  final String id;
  final String name;
  final String symbol;
  final double priceEur;
  final String imageUrl;

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.priceEur,
    required this.imageUrl,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'symbol': String symbol,
        'current_price': num priceEur,
        'image': String imageUrl,
      } =>
        Coin(
          id: id,
          name: name,
          symbol: symbol.toUpperCase(),
          priceEur: priceEur.toDouble(),
          imageUrl: imageUrl,
        ),
      _ => throw const FormatException('Failed to load Coin data.'),
    };
  }
}
