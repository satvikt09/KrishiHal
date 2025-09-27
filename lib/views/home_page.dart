import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'crop_page.dart';
import 'profile_page.dart';
import 'plant_disease_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeSection(),
    CropPage(),
    const PlantDiseasePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Krishiहल"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ---------------- Home Section ----------------
class _HomeSection extends StatelessWidget {
  const _HomeSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner with crop image
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/crop.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.38),
                ),
                const Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    "Welcome Farmer 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Weather Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.orange.shade400,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.white, size: 42),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "28°C — Sunny",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "No heavy rain expected. Good day for irrigation.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.white70),
                          const SizedBox(height: 6),
                          Text(
                            "Humidity\n68%",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
            // Daily Tip Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "💡 Daily Tip",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDailyTipCard(
              context,
              tip:
                  "Regularly check soil moisture levels. Over-irrigation can lead to root diseases.",
              color: Colors.blue.shade300,
              icon: Icons.lightbulb_outline,
            ),

            const SizedBox(height: 18),

            // Soil Health Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "🌿 Soil Health",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSoilHealthCard(
              context,
              moisture: "75%",
              nutrients: "Optimal",
              temperature: "25°C",
            ),

            const SizedBox(height: 18),

            // Today's Highlights
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "🌾 Today's Highlights",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _highlightCropCard(
                    context,
                    title: "Wheat",
                    subtitle:
                        "Best season for sowing. Ensure proper irrigation.",
                    marketPrice: "₹ 2400 / Quintal",
                    imagePath: "assets/wheat.png",
                    onTap: () {},
                    colors: [Colors.green.shade500, Colors.green.shade800],
                  ),
                  const SizedBox(height: 12),
                  _highlightCropCard(
                    context,
                    title: "Rice",
                    subtitle:
                        "High water availability detected. Plant during monsoon.",
                    marketPrice: "₹ 3500 / Quintal",
                    imagePath: "assets/rice.png",
                    onTap: () {},
                    colors: [Colors.teal.shade500, Colors.teal.shade800],
                  ),
                  const SizedBox(height: 12),
                  _highlightCropCard(
                    context,
                    title: "Maize",
                    subtitle: "Suitable for current weather. Follow spacing.",
                    marketPrice: "₹ 2150 / Quintal",
                    imagePath: "assets/maize.png",
                    onTap: () {},
                    colors: [Colors.green.shade400, Colors.green.shade700],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Helper method for the Quick Action Buttons
  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200, width: 1.5),
            ),
            child: Icon(icon, size: 35, color: Colors.green.shade700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.green.shade800),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper method for the Daily Tip Card
  Widget _buildDailyTipCard(
    BuildContext context, {
    required String tip,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for the Soil Health Card
  Widget _buildSoilHealthCard(
    BuildContext context, {
    required String moisture,
    required String nutrients,
    required String temperature,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSoilMetric(
              "Moisture",
              moisture,
              Icons.water_drop,
              Colors.blue,
            ),
            _buildSoilMetric("Nutrients", nutrients, Icons.eco, Colors.brown),
            _buildSoilMetric(
              "Temp.",
              temperature,
              Icons.thermostat,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the Soil Health Metrics
  Widget _buildSoilMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _highlightCropCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String marketPrice,
    required String imagePath,
    required VoidCallback onTap,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            marketPrice,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
