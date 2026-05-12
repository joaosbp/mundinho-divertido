/// Estado de uma missão.
enum MissionStatus { notStarted, inProgress, completed, abandoned }

/// Um passo de missão.
class MissionStep {
  final String id;
  final String description;
  final String? targetLocationId;
  final String? targetNpcId;
  final String? minigameId;
  final bool isOptional;

  const MissionStep({
    required this.id,
    required this.description,
    this.targetLocationId,
    this.targetNpcId,
    this.minigameId,
    this.isOptional = false,
  });
}

/// Recompensa de missão.
class MissionReward {
  final int stars;
  final int coins;
  final String? itemId;
  final String? stickerId;
  final String? unlockLocationId;

  const MissionReward({
    this.stars = 0,
    this.coins = 0,
    this.itemId,
    this.stickerId,
    this.unlockLocationId,
  });
}

/// Classe base para todas as missões.
///
/// Cada missão estende esta classe e registra-se no [MissionManager].
abstract class MissionBase {
  final String id;
  final String title;
  final String description;
  final String? arcId;
  final List<MissionStep> steps;
  final List<MissionReward> rewards;
  final List<String> prerequisiteMissionIds;
  final bool isRepeatable;

  MissionBase({
    required this.id,
    required this.title,
    required this.description,
    this.arcId,
    this.steps = const [],
    this.rewards = const [],
    this.prerequisiteMissionIds = const [],
    this.isRepeatable = false,
  });

  /// Verifica se a missão pode ser iniciada.
  bool canStart(Set<String> completedMissions) {
    return prerequisiteMissionIds.every(completedMissions.contains);
  }

  /// Chamado quando a missão inicia.
  void onStart() {
    // Override em subclasses
  }

  /// Chamado quando um passo é completado.
  void onStepComplete(int stepIndex) {
    // Override em subclasses
  }

  /// Chamado quando a missão é completada.
  List<MissionReward> onComplete() {
    return rewards;
  }
}
