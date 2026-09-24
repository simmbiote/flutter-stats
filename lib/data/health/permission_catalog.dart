import 'package:health/health.dart';

import '../../features/sync/domain/models.dart';

class PermissionDescriptor {
  const PermissionDescriptor({
    required this.recordType,
    required this.category,
    required this.healthTypes,
    required this.label,
    required this.description,
  });

  final String recordType;
  final HealthCategory category;
  final List<HealthDataType> healthTypes;
  final String label;
  final String description;
}

class PermissionCatalog {
  const PermissionCatalog();

  List<PermissionDescriptor> get all => const [
    PermissionDescriptor(
      recordType: 'steps',
      category: HealthCategory.activity,
      healthTypes: [HealthDataType.STEPS],
      label: 'Steps',
      description: 'Step counts from Health Connect sources.',
    ),
    PermissionDescriptor(
      recordType: 'distance',
      category: HealthCategory.activity,
      healthTypes: [HealthDataType.DISTANCE_WALKING_RUNNING],
      label: 'Distance',
      description: 'Walking and running distance.',
    ),
    PermissionDescriptor(
      recordType: 'active_calories',
      category: HealthCategory.activity,
      healthTypes: [HealthDataType.ACTIVE_ENERGY_BURNED],
      label: 'Active calories',
      description: 'Active energy expenditure.',
    ),
    PermissionDescriptor(
      recordType: 'exercise_session',
      category: HealthCategory.activity,
      healthTypes: [HealthDataType.EXERCISE_TIME, HealthDataType.WORKOUT],
      label: 'Exercise sessions',
      description: 'Exercise and workout sessions.',
    ),
    PermissionDescriptor(
      recordType: 'heart_rate',
      category: HealthCategory.vitals,
      healthTypes: [HealthDataType.HEART_RATE],
      label: 'Heart rate',
      description: 'Heart-rate measurements.',
    ),
    PermissionDescriptor(
      recordType: 'blood_pressure',
      category: HealthCategory.vitals,
      healthTypes: [
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ],
      label: 'Blood pressure',
      description: 'Systolic and diastolic blood pressure.',
    ),
    PermissionDescriptor(
      recordType: 'oxygen_saturation',
      category: HealthCategory.vitals,
      healthTypes: [HealthDataType.BLOOD_OXYGEN],
      label: 'Blood oxygen',
      description: 'Blood-oxygen saturation.',
    ),
    PermissionDescriptor(
      recordType: 'respiratory_rate',
      category: HealthCategory.vitals,
      healthTypes: [HealthDataType.RESPIRATORY_RATE],
      label: 'Respiratory rate',
      description: 'Breaths per minute.',
    ),
    PermissionDescriptor(
      recordType: 'body_temperature',
      category: HealthCategory.vitals,
      healthTypes: [HealthDataType.BODY_TEMPERATURE],
      label: 'Body temperature',
      description: 'Body-temperature measurements.',
    ),
    PermissionDescriptor(
      recordType: 'sleep',
      category: HealthCategory.sleep,
      healthTypes: [
        HealthDataType.SLEEP_SESSION,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_LIGHT,
        HealthDataType.SLEEP_REM,
      ],
      label: 'Sleep',
      description: 'Sleep sessions and stages.',
    ),
    PermissionDescriptor(
      recordType: 'weight',
      category: HealthCategory.bodyMeasurements,
      healthTypes: [HealthDataType.WEIGHT],
      label: 'Weight',
      description: 'Body mass measurements.',
    ),
    PermissionDescriptor(
      recordType: 'height',
      category: HealthCategory.bodyMeasurements,
      healthTypes: [HealthDataType.HEIGHT],
      label: 'Height',
      description: 'Height measurements.',
    ),
    PermissionDescriptor(
      recordType: 'body_fat',
      category: HealthCategory.bodyMeasurements,
      healthTypes: [HealthDataType.BODY_FAT_PERCENTAGE],
      label: 'Body fat',
      description: 'Body-fat percentage.',
    ),
    PermissionDescriptor(
      recordType: 'bmi',
      category: HealthCategory.bodyMeasurements,
      healthTypes: [HealthDataType.BODY_MASS_INDEX],
      label: 'BMI',
      description: 'Body mass index.',
    ),
  ];

  List<String> get recordTypes => all.map((item) => item.recordType).toList();

  PermissionDescriptor? byRecordType(String recordType) {
    for (final descriptor in all) {
      if (descriptor.recordType == recordType) return descriptor;
    }
    return null;
  }

  List<HealthDataType> healthTypesFor(Iterable<String> recordTypes) {
    final result = <HealthDataType>[];
    for (final recordType in recordTypes) {
      final descriptor = byRecordType(recordType);
      if (descriptor != null) {
        result.addAll(descriptor.healthTypes);
      }
    }
    return result.toSet().toList(growable: false);
  }

  HealthCategory categoryFor(String recordType) {
    return byRecordType(recordType)?.category ?? HealthCategory.activity;
  }
}
