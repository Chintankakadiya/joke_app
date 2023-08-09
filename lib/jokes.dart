class Joke {
  final String value;
  final DateTime dateTime;

  Joke({required this.value, required this.dateTime});
  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      value: json['value'],
      dateTime: DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
