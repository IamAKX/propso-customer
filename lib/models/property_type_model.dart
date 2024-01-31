import 'dart:convert';

class PropertyTypeModel {
  int? id;
  String? name;
  String? iconPath;
  PropertyTypeModel({
    this.id,
    this.name,
    this.iconPath,
  });

  PropertyTypeModel copyWith({
    int? id,
    String? name,
    String? iconPath,
  }) {
    return PropertyTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
    };
  }

  factory PropertyTypeModel.fromMap(Map<String, dynamic> map) {
    return PropertyTypeModel(
      id: map['id']?.toInt(),
      name: map['name'],
      iconPath: map['iconPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyTypeModel.fromJson(String source) => PropertyTypeModel.fromMap(json.decode(source));

  @override
  String toString() => 'PropertyTypeModel(id: $id, name: $name, iconPath: $iconPath)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PropertyTypeModel &&
      other.id == id &&
      other.name == name &&
      other.iconPath == iconPath;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ iconPath.hashCode;
}
