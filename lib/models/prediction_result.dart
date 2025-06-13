class PredictionResult {
  final int? id;
  final String label;
  final double confidence;
  final double moisture;
  final String imagePath;
  final String timestamp;

  PredictionResult({
    this.id,
    required this.label,
    required this.confidence,
    required this.moisture,
    required this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'confidence': confidence,
      'moisture': moisture,
      'imagePath': imagePath,
      'timestamp': timestamp,
    };
  }

  factory PredictionResult.fromMap(Map<String, dynamic> map) {
    return PredictionResult(
      id: map['id'],
      label: map['label'],
      confidence: map['confidence'],
      moisture: map['moisture'],
      imagePath: map['imagePath'],
      timestamp: map['timestamp'],
    );
  }
}