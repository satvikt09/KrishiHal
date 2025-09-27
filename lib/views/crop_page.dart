import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropPage extends StatefulWidget {
  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  // Use a GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  List<String> topCrops = [];
  String recommendedFertilizer = "";
  bool loading = false;

  // --- API Prediction Logic (Unchanged) ---
  Future<void> predictCrops() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final n = nController.text;
    final p = pController.text;
    final k = kController.text;
    final ph = phController.text;
    final city = cityController.text;

    setState(() {
      loading = true;
      topCrops = [];
      recommendedFertilizer = "";
    });

    try {
      // NOTE: The IP address is hardcoded. Consider using a configuration variable.
      final url = Uri.parse('http://172.20.24.153:5000/predict');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "N": int.parse(n),
          "P": int.parse(p),
          "K": int.parse(k),
          "ph": double.parse(ph),
          "city": city,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          topCrops = List<String>.from(data['top3_crops']);
          recommendedFertilizer = data['recommended_fertilizer'];
          loading = false;
        });
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error communicating with API. Check IP/Connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- Widget for modern input fields ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    // Define a professional, agriculture-themed color palette
    final Color primaryColor = Colors.green[700]!;
    final Color accentColor = Colors.lightGreen[400]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Crop & Fertilizer Advisor 🌱",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        // Set a light, subtle background color
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Input Form Card ---
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Soil and Location Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Divider(color: Colors.grey[300]),
                        SizedBox(height: 10),

                        // N Input
                        _buildTextField(
                          controller: nController,
                          label: "Nitrogen (N) Content",
                          hint: "Enter N value (e.g., 90)",
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  value == null || int.tryParse(value) == null
                                      ? 'Enter a valid number for N'
                                      : null,
                        ),
                        // P Input
                        _buildTextField(
                          controller: pController,
                          label: "Phosphorus (P) Content",
                          hint: "Enter P value (e.g., 42)",
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  value == null || int.tryParse(value) == null
                                      ? 'Enter a valid number for P'
                                      : null,
                        ),
                        // K Input
                        _buildTextField(
                          controller: kController,
                          label: "Potassium (K) Content",
                          hint: "Enter K value (e.g., 43)",
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  value == null || int.tryParse(value) == null
                                      ? 'Enter a valid number for K'
                                      : null,
                        ),
                        // pH Input
                        _buildTextField(
                          controller: phController,
                          label: "Soil pH Level",
                          hint: "Enter pH value (e.g., 6.5)",
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator:
                              (value) =>
                                  value == null ||
                                          double.tryParse(value) == null
                                      ? 'Enter a valid number for pH'
                                      : null,
                        ),
                        // City Input
                        _buildTextField(
                          controller: cityController,
                          label: "Current City/Location",
                          hint: "Enter the city name (e.g., Bangalore)",
                          keyboardType: TextInputType.text,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'City cannot be empty'
                                      : null,
                        ),

                        SizedBox(height: 10),
                        // Predict Button
                        ElevatedButton.icon(
                          onPressed: loading ? null : predictCrops,
                          icon:
                              loading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Icon(Icons.psychology_outlined),
                          label: Text(
                            loading ? "Predicting..." : "Get Recommendations",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // --- Results Display Section ---
              if (topCrops.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Crop Recommendations Card
                    _buildResultCard(
                      icon: Icons.agriculture_outlined,
                      title: "Top Crop Recommendations",
                      color: primaryColor,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            topCrops.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              String crop = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "$index. ${crop.toUpperCase()}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            index == 1
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Fertilizer Recommendation Card
                    _buildResultCard(
                      icon: Icons.science_outlined,
                      title: "Recommended Fertilizer",
                      color: accentColor,
                      content: Text(
                        recommendedFertilizer.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a consistent result card style
  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], height: 25),
            content,
          ],
        ),
      ),
    );
  }
}
