import 'package:hive/hive.dart';

/// Dados salvos do jogador.
@HiveType(typeId: 0)
class PlayerData extends HiveObject {
  @HiveField(0)
  String playerName;

  @HiveField(1)
  int coins;

  @HiveField(2)
  int stars;

  @HiveField(3)
  List<String> unlockedLocations;

  @HiveField(4)
  List<String> completedMissions;

  @HiveField(5)
  List<String> collectedStickers;

  @HiveField(6)
  Map<String, int> miniGameHighScores;

  @HiveField(7)
  DateTime lastPlayed;

  @HiveField(8)
  int totalPlayTimeMinutes;

  @HiveField(9)
  Map<String, int> npcFriendship;

  PlayerData({
    required this.playerName,
    required this.coins,
    required this.stars,
    required this.unlockedLocations,
    required this.completedMissions,
    required this.collectedStickers,
    required this.miniGameHighScores,
    required this.lastPlayed,
    required this.totalPlayTimeMinutes,
    required this.npcFriendship,
  });

  factory PlayerData.defaultData() => PlayerData(
        playerName: 'Jogador',
        coins: 0,
        stars: 0,
        unlockedLocations: ['casa_jogador', 'praca_central'],
        completedMissions: [],
        collectedStickers: [],
        miniGameHighScores: {},
        lastPlayed: DateTime.now(),
        totalPlayTimeMinutes: 0,
        npcFriendship: {},
      );

  PlayerData copyWith({
    String? playerName,
    int? coins,
    int? stars,
    List<String>? unlockedLocations,
    List<String>? completedMissions,
    List<String>? collectedStickers,
    Map<String, int>? miniGameHighScores,
    DateTime? lastPlayed,
    int? totalPlayTimeMinutes,
    Map<String, int>? npcFriendship,
  }) {
    return PlayerData(
      playerName: playerName ?? this.playerName,
      coins: coins ?? this.coins,
      stars: stars ?? this.stars,
      unlockedLocations: unlockedLocations ?? List.from(this.unlockedLocations),
      completedMissions: completedMissions ?? List.from(this.completedMissions),
      collectedStickers: collectedStickers ?? List.from(this.collectedStickers),
      miniGameHighScores: miniGameHighScores ?? Map.from(this.miniGameHighScores),
      lastPlayed: lastPlayed ?? this.lastPlayed,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      npcFriendship: npcFriendship ?? Map.from(this.npcFriendship),
    );
  }
}

// Placeholder adapter — será gerado via build_runner
// Comando: flutter packages pub run build_runner build
class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData(
      playerName: fields[0] as String,
      coins: fields[1] as int,
      stars: fields[2] as int,
      unlockedLocations: (fields[3] as List).cast<String>(),
      completedMissions: (fields[4] as List).cast<String>(),
      collectedStickers: (fields[5] as List).cast<String>(),
      miniGameHighScores: (fields[6] as Map).cast<String, int>(),
      lastPlayed: fields[7] as DateTime,
      totalPlayTimeMinutes: fields[8] as int,
      npcFriendship: (fields[9] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.playerName)
      ..writeByte(1)
      ..write(obj.coins)
      ..writeByte(2)
      ..write(obj.stars)
      ..writeByte(3)
      ..write(obj.unlockedLocations)
      ..writeByte(4)
      ..write(obj.completedMissions)
      ..writeByte(5)
      ..write(obj.collectedStickers)
      ..writeByte(6)
      ..write(obj.miniGameHighScores)
      ..writeByte(7)
      ..write(obj.lastPlayed)
      ..writeByte(8)
      ..write(obj.totalPlayTimeMinutes)
      ..writeByte(9)
      ..write(obj.npcFriendship);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
