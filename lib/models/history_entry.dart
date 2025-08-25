// HistoryEntry model for calculator history entries
class HistoryEntry {
  final String calculation;
  final DateTime timestamp;

  HistoryEntry(this.calculation, this.timestamp);

  // Convert HistoryEntry to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'calculation': calculation,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create HistoryEntry from a Map
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      json['calculation'],
      DateTime.parse(json['timestamp']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEntry &&
          runtimeType == other.runtimeType &&
          calculation == other.calculation &&
          timestamp == other.timestamp;

  @override
  int get hashCode => calculation.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'HistoryEntry{calculation: $calculation, timestamp: $timestamp}';
  }
}
