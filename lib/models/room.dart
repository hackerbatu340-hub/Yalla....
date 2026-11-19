class Speaker {
  final String uid;
  final String name;
  final bool isHost;
  final bool muted;

  Speaker({
    required this.uid,
    required this.name,
    required this.isHost,
    this.muted = false,
  });

  factory Speaker.fromMap(Map<dynamic, dynamic> map) => Speaker(
        uid: map['uid']?.toString() ?? '',
        name: map['name'] ?? '?',
        isHost: map['isHost'] ?? false,
        muted: map['muted'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'isHost': isHost,
        'muted': muted,
      };
}

class Room {
  final String id;
  final String name;
  final String topic;
  final String hostName;
  final int listenerCount;
  final Map<String, Speaker> speakers;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.name,
    required this.topic,
    required this.hostName,
    required this.listenerCount,
    required this.createdAt,
    this.speakers = const {},
  });

  factory Room.fromMap(String id, Map<dynamic, dynamic> map) {
    final speakersRaw = map['speakers'] as Map<dynamic, dynamic>? ?? {};
    return Room(
      id: id,
      name: map['name'] ?? 'Oda',
      topic: map['topic'] ?? '',
      hostName: map['hostName'] ?? '',
      listenerCount: map['listenerCount'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      speakers: speakersRaw.map((k, v) =>
          MapEntry(k.toString(), Speaker.fromMap(v as Map<dynamic, dynamic>))),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'topic': topic,
        'hostName': hostName,
        'listenerCount': listenerCount,
        'createdAt': createdAt.toIso8601String(),
      };
}
