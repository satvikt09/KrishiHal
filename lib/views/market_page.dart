import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Prices"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // 👈 Fix overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search crop...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Market Prices Section
            const Text(
              "Ongoing Prices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildMarketCard("Wheat", "₹2200 / Quintal"),
            _buildMarketCard("Rice", "₹1800 / Quintal"),
            _buildMarketCard("Maize", "₹1500 / Quintal"),
            _buildMarketCard("Cotton", "₹6200 / Quintal"),
            _buildMarketCard("Soybean", "₹4300 / Quintal"),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketCard(String crop, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_grocery_store, color: Colors.green),
        title: Text(crop, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
