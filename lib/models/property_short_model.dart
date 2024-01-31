import 'dart:convert';

class PropertyShortModel {
  String? type;
  int? propertyId;
  PropertyShortModel({
    this.type,
    this.propertyId,
  });

  PropertyShortModel copyWith({
    String? type,
    int? propertyId,
  }) {
    return PropertyShortModel(
      type: type ?? this.type,
      propertyId: propertyId ?? this.propertyId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(type != null){
      result.addAll({'type': type});
    }
    if(propertyId != null){
      result.addAll({'propertyId': propertyId});
    }
  
    return result;
  }

  factory PropertyShortModel.fromMap(Map<String, dynamic> map) {
    return PropertyShortModel(
      type: map['type'],
      propertyId: map['propertyId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyShortModel.fromJson(String source) => PropertyShortModel.fromMap(json.decode(source));

  @override
  String toString() => 'PropertyShortModel(type: $type, propertyId: $propertyId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PropertyShortModel &&
      other.type == type &&
      other.propertyId == propertyId;
  }

  @override
  int get hashCode => type.hashCode ^ propertyId.hashCode;
}
