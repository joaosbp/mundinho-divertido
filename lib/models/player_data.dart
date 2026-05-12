import 'package:hive/hive.dart';

import 'settings_data.dart';

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

  @HiveField(10)
  List<String> inventory;

  @HiveField(11)
  List<String> visitedLocations;

  @HiveField(12)
  List<String> completedMiniGames;

  @HiveField(13)
  SettingsData settings;

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
    required this.inventory,
    required this.visitedLocations,
    required this.completedMiniGames,
    required this.settings,
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
        inventory: [],
        visitedLocations: [],
        completedMiniGames: [],
        settings: SettingsData.defaultData(),
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
    List<String>? inventory,
    List<String>? visitedLocations,
    List<String>? completedMiniGames,
    SettingsData? settings,
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
      inventory: inventory ?? List.from(this.inventory),
      visitedLocations: visitedLocations ?? List.from(this.visitedLocations),
      completedMiniGames: completedMiniGames ?? List.from(this.completedMiniGames),
      settings: settings ?? this.settings.copyWith(),
    );
  }

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'coins': coins,
        'stars': stars,
        'unlockedLocations': unlockedLocations,
        'completedMissions': completedMissions,
        'collectedStickers': collectedStickers,
        'miniGameHighScores': miniGameHighScores,
        'lastPlayed': lastPlayed.toIso8601String(),
        'totalPlayTimeMinutes': totalPlayTimeMinutes,
        'npcFriendship': npcFriendship,
        'inventory': inventory,
        'visitedLocations': visitedLocations,
        'completedMiniGames': completedMiniGames,
        'settings': settings.toJson(),
      };

  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
        playerName: json['playerName'] as String? ?? 'Jogador',
        coins: json['coins'] as int? ?? 0,
        stars: json['stars'] as int? ?? 0,
        unlockedLocations: (json['unlockedLocations'] as List<dynamic>?)
                ?.cast<String>() ??
            ['casa_jogador', 'praca_central'],
        completedMissions:
            (json['completedMissions'] as List<dynamic>?)?.cast<String>() ?? [],
        collectedStickers:
            (json['collectedStickers'] as List<dynamic>?)?.cast<String>() ?? [],
        miniGameHighScores:
            (json['miniGameHighScores'] as Map<String, dynamic>?)
                    ?.cast<String, int>() ??
                {},
        lastPlayed: DateTime.tryParse(json['lastPlayed'] as String? ?? '') ??
            DateTime.now(),
        totalPlayTimeMinutes: json['totalPlayTimeMinutes'] as int? ?? 0,
        npcFriendship: (json['npcFriendship'] as Map<String, dynamic>?)
                ?.cast<String, int>() ??
            {},
        inventory:
            (json['inventory'] as List<dynamic>?)?.cast<String>() ?? [],
        visitedLocations:
            (json['visitedLocations'] as List<dynamic>?)?.cast<String>() ?? [],
        completedMiniGames:
            (json['completedMiniGames'] as List<dynamic>?)?.cast<String>() ??
                [],
        settings: json['settings'] != null
            ? SettingsData.fromJson(
                json['settings'] as Map<String, dynamic>)
            : SettingsData.defaultData(),
      );
}

/// TypeAdapter manual para Hive (sem build_runner).
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
      inventory: (fields[10] as List?)?.cast<String>() ?? [],
      visitedLocations: (fields[11] as List?)?.cast<String>() ?? [],
      completedMiniGames: (fields[12] as List?)?.cast<String>() ?? [],
      settings: fields[13] as SettingsData? ?? SettingsData.defaultData(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.npcFriendship)
      ..writeByte(10)
      ..write(obj.inventory)
      ..writeByte(11)
      ..write(obj.visitedLocations)
      ..writeByte(12)
      ..write(obj.completedMiniGames)
      ..writeByte(13)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
