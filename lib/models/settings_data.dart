import 'package:hive/hive.dart';

part 'settings_data.g.dart';

/// Configurações do jogador.
@HiveType(typeId: 1)
class SettingsData extends HiveObject {
  @HiveField(0)
  bool soundOn;

  @HiveField(1)
  bool musicOn;

  @HiveField(2)
  bool vibrationOn;

  @HiveField(3)
  bool narrationOn;

  @HiveField(4)
  double textSizeScale;

  @HiveField(5)
  bool highContrast;

  @HiveField(6)
  bool colorBlindMode;

  @HiveField(7)
  bool analyticsEnabled;

  @HiveField(8)
  bool crashReportingEnabled;

  @HiveField(9)
  String language;

  SettingsData({
    required this.soundOn,
    required this.musicOn,
    required this.vibrationOn,
    required this.narrationOn,
    required this.textSizeScale,
    required this.highContrast,
    required this.colorBlindMode,
    required this.analyticsEnabled,
    required this.crashReportingEnabled,
    required this.language,
  });

  factory SettingsData.defaultData() => SettingsData(
        soundOn: true,
        musicOn: true,
        vibrationOn: true,
        narrationOn: true,
        textSizeScale: 1.0,
        highContrast: false,
        colorBlindMode: false,
        analyticsEnabled: false, // opt-in por padrão (LGPD/COPPA)
        crashReportingEnabled: false, // opt-in por padrão
        language: 'pt_BR',
      );

  SettingsData copyWith({
    bool? soundOn,
    bool? musicOn,
    bool? vibrationOn,
    bool? narrationOn,
    double? textSizeScale,
    bool? highContrast,
    bool? colorBlindMode,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
    String? language,
  }) {
    return SettingsData(
      soundOn: soundOn ?? this.soundOn,
      musicOn: musicOn ?? this.musicOn,
      vibrationOn: vibrationOn ?? this.vibrationOn,
      narrationOn: narrationOn ?? this.narrationOn,
      textSizeScale: textSizeScale ?? this.textSizeScale,
      highContrast: highContrast ?? this.highContrast,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled: crashReportingEnabled ?? this.crashReportingEnabled,
      language: language ?? this.language,
    );
  }
}

// Placeholder adapter
class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final int typeId = 1;

  @override
  SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsData(
      soundOn: fields[0] as bool,
      musicOn: fields[1] as bool,
      vibrationOn: fields[2] as bool,
      narrationOn: fields[3] as bool,
      textSizeScale: fields[4] as double,
      highContrast: fields[5] as bool,
      colorBlindMode: fields[6] as bool,
      analyticsEnabled: fields[7] as bool,
      crashReportingEnabled: fields[8] as bool,
      language: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.soundOn)
      ..writeByte(1)
      ..write(obj.musicOn)
      ..writeByte(2)
      ..write(obj.vibrationOn)
      ..writeByte(3)
      ..write(obj.narrationOn)
      ..writeByte(4)
      ..write(obj.textSizeScale)
      ..writeByte(5)
      ..write(obj.highContrast)
      ..writeByte(6)
      ..write(obj.colorBlindMode)
      ..writeByte(7)
      ..write(obj.analyticsEnabled)
      ..writeByte(8)
      ..write(obj.crashReportingEnabled)
      ..writeByte(9)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
