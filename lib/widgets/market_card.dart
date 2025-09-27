import 'package:flutter/material.dart';
import '../models/market_price_model.dart';

class MarketCard extends StatelessWidget {
  final MarketPrice price;

  const MarketCard({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price.cropName,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              "₹${price.pricePerKg.toStringAsFixed(2)}/Kg",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
