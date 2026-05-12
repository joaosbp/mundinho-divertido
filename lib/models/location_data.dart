/// Dados imutáveis de um local da cidade.
class LocationData {
  final String id;
  final String name;
  final String districtId;
  final String description;
  final String? exteriorAssetPath;
  final String? interiorAssetPath;
  final List<String> npcIds;
  final List<String> minigameIds;
  final List<String> missionIds;
  final String? operatingHours; // ex: "08:00-18:00" ou "24h"
  final bool isUnlockedByDefault;

  const LocationData({
    required this.id,
    required this.name,
    required this.districtId,
    required this.description,
    this.exteriorAssetPath,
    this.interiorAssetPath,
    this.npcIds = const [],
    this.minigameIds = const [],
    this.missionIds = const [],
    this.operatingHours,
    this.isUnlockedByDefault = false,
  });

  LocationData copyWith({
    String? id,
    String? name,
    String? districtId,
    String? description,
    String? exteriorAssetPath,
    String? interiorAssetPath,
    List<String>? npcIds,
    List<String>? minigameIds,
    List<String>? missionIds,
    String? operatingHours,
    bool? isUnlockedByDefault,
  }) {
    return LocationData(
      id: id ?? this.id,
      name: name ?? this.name,
      districtId: districtId ?? this.districtId,
      description: description ?? this.description,
      exteriorAssetPath: exteriorAssetPath ?? this.exteriorAssetPath,
      interiorAssetPath: interiorAssetPath ?? this.interiorAssetPath,
      npcIds: npcIds ?? List.from(this.npcIds),
      minigameIds: minigameIds ?? List.from(this.minigameIds),
      missionIds: missionIds ?? List.from(this.missionIds),
      operatingHours: operatingHours ?? this.operatingHours,
      isUnlockedByDefault: isUnlockedByDefault ?? this.isUnlockedByDefault,
    );
  }
}
