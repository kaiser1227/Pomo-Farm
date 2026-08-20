class TomatoFarmModel {
  final double currentGrowth; // 0.0 to 100.0
  final int harvestCount;
  final int waterCount;
  final int totalWaterUsed;
  final List<String> ownedAccessories;
  final String? equippedAccessory;

  TomatoFarmModel({
    this.currentGrowth = 0.0,
    this.harvestCount = 0,
    this.waterCount = 0,
    this.totalWaterUsed = 0,
    this.ownedAccessories = const [],
    this.equippedAccessory,
  });

  TomatoFarmModel copyWith({
    double? currentGrowth,
    int? harvestCount,
    int? waterCount,
    int? totalWaterUsed,
    List<String>? ownedAccessories,
    String? equippedAccessory,
    bool clearEquipped = false,
  }) {
    return TomatoFarmModel(
      currentGrowth: currentGrowth ?? this.currentGrowth,
      harvestCount: harvestCount ?? this.harvestCount,
      waterCount: waterCount ?? this.waterCount,
      totalWaterUsed: totalWaterUsed ?? this.totalWaterUsed,
      ownedAccessories: ownedAccessories ?? this.ownedAccessories,
      equippedAccessory: clearEquipped ? null : (equippedAccessory ?? this.equippedAccessory),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentGrowth': currentGrowth,
      'harvestCount': harvestCount,
      'waterCount': waterCount,
      'totalWaterUsed': totalWaterUsed,
      'ownedAccessories': ownedAccessories,
      'equippedAccessory': equippedAccessory,
    };
  }

  factory TomatoFarmModel.fromJson(Map<String, dynamic> json) {
    return TomatoFarmModel(
      currentGrowth: (json['currentGrowth'] ?? 0.0).toDouble(),
      harvestCount: json['harvestCount'] ?? 0,
      waterCount: json['waterCount'] ?? 0,
      totalWaterUsed: json['totalWaterUsed'] ?? 0,
      ownedAccessories: List<String>.from(json['ownedAccessories'] ?? []),
      equippedAccessory: json['equippedAccessory'],
    );
  }
}
