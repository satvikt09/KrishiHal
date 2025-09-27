import 'dart:convert';
import 'package:http/http.dart' as http;

class CropController {
  final String apiUrl =
      'http://192.168.43.91:5000/predict'; // replace with your Flask server IP

  /// Predict crops and fertilizer
  Future<Map<String, dynamic>> getPredictions({
    required double N,
    required double P,
    required double K,
    required double ph,
    required String city,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'N': N, 'P': P, 'K': K, 'ph': ph, 'city': city}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Returns top crops and fertilizer
        return {
          'top3_crops': List<String>.from(data['top3_crops']),
          'recommended_fertilizer': data['recommended_fertilizer'],
          'weather': data['weather'],
        };
      } else {
        throw Exception('Failed to get predictions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
