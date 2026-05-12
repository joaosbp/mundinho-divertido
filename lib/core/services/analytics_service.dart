import 'dart:developer' as developer;
import 'package:firebase_analytics/firebase_analytics.dart';

/// Serviço de analytics — opt-in, desabilitado por padrão.
///
/// Regra: nenhum dado é enviado sem consentimento verificável do responsável.
/// Ver [LGPD.md] para conformidade.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool _enabled = false;

  bool get isEnabled => _enabled;

  /// Habilita/desabilita coleta de analytics.
  /// Deve ser chamado apenas após consentimento parental.
  void setEnabled(bool enabled) {
    _enabled = enabled;
    _analytics.setAnalyticsCollectionEnabled(enabled);
    developer.log('Analytics ${_enabled ? "enabled" : "disabled"}');
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_enabled) return;
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      developer.log('Analytics error: $e');
    }
  }

  // ─── Eventos de jornada ───

  Future<void> logAppOpen({String? source}) => logEvent(
        name: 'app_open',
        parameters: source != null ? {'source': source} : null,
      );

  Future<void> logFirstOpen({String? referrer}) => logEvent(
        name: 'first_open',
        parameters: referrer != null ? {'referrer': referrer} : null,
      );

  Future<void> logSessionStart() => logEvent(name: 'session_start');

  Future<void> logSessionEnd({required int durationSeconds}) => logEvent(
        name: 'session_end',
        parameters: {'duration_seconds': durationSeconds},
      );

  // ─── Eventos de gameplay ───

  Future<void> logLocationEnter(String locationId, String districtId) =>
      logEvent(
        name: 'location_enter',
        parameters: {'location_id': locationId, 'district_id': districtId},
      );

  Future<void> logNpcInteract(String npcId, String interactionType) =>
      logEvent(
        name: 'npc_interact',
        parameters: {'npc_id': npcId, 'interaction_type': interactionType},
      );

  Future<void> logMissionStart(String missionId) => logEvent(
        name: 'mission_start',
        parameters: {'mission_id': missionId},
      );

  Future<void> logMissionComplete({
    required String missionId,
    required int durationSeconds,
    required int starsEarned,
  }) =>
      logEvent(
        name: 'mission_complete',
        parameters: {
          'mission_id': missionId,
          'duration_seconds': durationSeconds,
          'stars_earned': starsEarned,
        },
      );

  Future<void> logMinigameStart(String minigameId) => logEvent(
        name: 'minigame_start',
        parameters: {'minigame_id': minigameId},
      );

  Future<void> logMinigameComplete({
    required String minigameId,
    required int score,
    required int stars,
  }) =>
      logEvent(
        name: 'minigame_complete',
        parameters: {
          'minigame_id': minigameId,
          'score': score,
          'stars': stars,
        },
      );

  // ─── Eventos de monetização ───

  Future<void> logTrialStarted({String? source}) => logEvent(
        name: 'trial_started',
        parameters: source != null ? {'source': source} : null,
      );

  Future<void> logSubscriptionViewed(String planType) => logEvent(
        name: 'subscription_viewed',
        parameters: {'plan_type': planType},
      );

  Future<void> logSubscriptionPurchased({
    required String planType,
    required double price,
  }) =>
      logEvent(
        name: 'subscription_purchased',
        parameters: {'plan_type': planType, 'price': price},
      );

  // ─── Eventos do painel dos pais ───

  Future<void> logParentDashboardOpen() =>
      logEvent(name: 'parent_dashboard_open');
}
