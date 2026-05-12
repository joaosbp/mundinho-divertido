/// Tempos e durações padronizadas.
class AppTimings {
  AppTimings._();

  // Feedback
  static const Duration feedbackFast = Duration(milliseconds: 100);
  static const Duration feedbackNormal = Duration(milliseconds: 200);
  static const Duration feedbackSlow = Duration(milliseconds: 500);

  // Animações
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 600);

  // Gameplay
  static const Duration dayNightCycle = Duration(minutes: 15);
  static const Duration hintDelay = Duration(seconds: 15);
  static const Duration autoSaveInterval = Duration(minutes: 2);
}
