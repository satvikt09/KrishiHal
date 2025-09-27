class PlantDisease {
  final String disease;
  final double confidence;

  PlantDisease({required this.disease, required this.confidence});

  factory PlantDisease.fromJson(Map<String, dynamic> json) {
    return PlantDisease(
      disease: json['disease'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}
