import 'dart:developer' as developer;

import '../core/services/analytics_service.dart';
import 'mission_base.dart';

/// Registro e tracker de progressão de missões.
class MissionManager {
  static final MissionManager _instance = MissionManager._internal();
  factory MissionManager() => _instance;
  MissionManager._internal();

  final Map<String, MissionBase> _missions = {};
  final Set<String> _completed = {};
  final Map<String, int> _currentStep = {}; // missionId -> stepIndex

  List<MissionBase> get allMissions => List.unmodifiable(_missions.values);

  List<MissionBase> get availableMissions {
    return _missions.values.where((m) {
      if (_completed.contains(m.id) && !m.isRepeatable) return false;
      return m.canStart(_completed);
    }).toList();
  }

  List<MissionBase> get inProgressMissions {
    return _missions.values
        .where((m) => _currentStep.containsKey(m.id) && !_completed.contains(m.id))
        .toList();
  }

  List<MissionBase> get completedMissions {
    return _missions.values.where((m) => _completed.contains(m.id)).toList();
  }

  void register(MissionBase mission) {
    _missions[mission.id] = mission;
    developer.log('Mission registered: ${mission.id}');
  }

  MissionBase? get(String id) => _missions[id];

  /// Inicia uma missão.
  bool start(String missionId) {
    final mission = _missions[missionId];
    if (mission == null) return false;
    if (!mission.canStart(_completed)) return false;
    if (_completed.contains(missionId) && !mission.isRepeatable) return false;

    _currentStep[missionId] = 0;
    mission.onStart();
    AnalyticsService().logMissionStart(missionId);
    return true;
  }

  /// Avança para o próximo passo da missão.
  bool advanceStep(String missionId) {
    final mission = _missions[missionId];
    if (mission == null) return false;

    final current = _currentStep[missionId] ?? 0;
    if (current < mission.steps.length - 1) {
      _currentStep[missionId] = current + 1;
      mission.onStepComplete(current + 1);
      return true;
    }
    return false;
  }

  /// Completa a missão.
  List<MissionReward> complete(String missionId) {
    final mission = _missions[missionId];
    if (mission == null) return [];

    _completed.add(missionId);
    _currentStep.remove(missionId);

    final rewards = mission.onComplete();
    AnalyticsService().logMissionComplete(
      missionId: missionId,
      durationSeconds: 0, // TODO: calcular duração real
      starsEarned: rewards.fold(0, (sum, r) => sum + r.stars),
    );
    return rewards;
  }

  /// Abandona a missão.
  void abandon(String missionId) {
    _currentStep.remove(missionId);
    developer.log('Mission abandoned: $missionId');
  }

  /// Carrega progresso salvo.
  void loadProgress(List<String> completedIds, Map<String, int> stepProgress) {
    _completed.addAll(completedIds);
    _currentStep.addAll(stepProgress);
  }

  /// Exporta progresso para salvar.
  ({List<String> completed, Map<String, int> steps}) exportProgress() {
    return (
      completed: List.unmodifiable(_completed),
      steps: Map.unmodifiable(_currentStep),
    );
  }
}
