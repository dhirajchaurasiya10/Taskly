class Tassk {
  String content;
  DateTime timestamp;
  bool done;

  Tassk({
    required this.content,
    required this.done,
    required this.timestamp,
  });

  factory Tassk.fromMap(Map tassk) {
    return Tassk(
      content: tassk["content"],
      done: tassk["done"],
      timestamp: tassk["timestamp"],
    );
  }

  Map toMap() {
    return {
      "content": content,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
