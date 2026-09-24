class SourceOriginMapper {
  const SourceOriginMapper();

  String originFor({required String sourceName, String? sourceId}) {
    final normalized = '${sourceId ?? ''} $sourceName'.toLowerCase();
    if (normalized.contains('samsung') || normalized.contains('shealth')) {
      return 'samsung_health';
    }
    return 'unknown';
  }

  String displaySource({required String sourceName, String? sourceId}) {
    if (sourceName.trim().isEmpty) return sourceId ?? 'Unknown source';
    return sourceName;
  }
}
