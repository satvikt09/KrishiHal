import '../models/market_price_model.dart';

class MarketController {
  List<MarketPrice> getMarketPrices() {
    return [
      MarketPrice(cropName: "Wheat", pricePerKg: 35.0),
      MarketPrice(cropName: "Rice", pricePerKg: 32.5),
      MarketPrice(cropName: "Maize", pricePerKg: 28.0),
      MarketPrice(cropName: "Sugarcane", pricePerKg: 20.0),
    ];
  }
}
