import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:propertycp_customer/models/property_media.dart';


class PropertyModel {
  int? id;
  String? title;
  String? subTitle;
  String? price;
  String? numberOfRooms;
  String? bhk;
  String? location;
  String? city;
  String? mainImage;
  List<PropertyMedia>? images;
  String? type;
  String? area;
  String? areaUnit;
  String? description;
  String? createdDate;
  String? updatedDate;
  String? builderPhoneNumber;
  PropertyModel({
    this.id,
    this.title,
    this.subTitle,
    this.price,
    this.numberOfRooms,
    this.bhk,
    this.location,
    this.city,
    this.mainImage,
    this.images,
    this.type,
    this.area,
    this.areaUnit,
    this.description,
    this.createdDate,
    this.updatedDate,
    this.builderPhoneNumber,
  });

  PropertyModel copyWith({
    int? id,
    String? title,
    String? subTitle,
    String? price,
    String? numberOfRooms,
    String? bhk,
    String? location,
    String? city,
    String? mainImage,
    List<PropertyMedia>? images,
    String? type,
    String? area,
    String? areaUnit,
    String? description,
    String? createdDate,
    String? updatedDate,
    String? builderPhoneNumber,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      price: price ?? this.price,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      bhk: bhk ?? this.bhk,
      location: location ?? this.location,
      city: city ?? this.city,
      mainImage: mainImage ?? this.mainImage,
      images: images ?? this.images,
      type: type ?? this.type,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      builderPhoneNumber: builderPhoneNumber ?? this.builderPhoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(title != null){
      result.addAll({'title': title});
    }
    if(subTitle != null){
      result.addAll({'subTitle': subTitle});
    }
    if(price != null){
      result.addAll({'price': price});
    }
    if(numberOfRooms != null){
      result.addAll({'numberOfRooms': numberOfRooms});
    }
    if(bhk != null){
      result.addAll({'bhk': bhk});
    }
    if(location != null){
      result.addAll({'location': location});
    }
    if(city != null){
      result.addAll({'city': city});
    }
    if(mainImage != null){
      result.addAll({'mainImage': mainImage});
    }
    if(images != null){
      result.addAll({'images': images!.map((x) => x?.toMap()).toList()});
    }
    if(type != null){
      result.addAll({'type': type});
    }
    if(area != null){
      result.addAll({'area': area});
    }
    if(areaUnit != null){
      result.addAll({'areaUnit': areaUnit});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    if(createdDate != null){
      result.addAll({'createdDate': createdDate});
    }
    if(updatedDate != null){
      result.addAll({'updatedDate': updatedDate});
    }
    if(builderPhoneNumber != null){
      result.addAll({'builderPhoneNumber': builderPhoneNumber});
    }
  
    return result;
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id']?.toInt(),
      title: map['title'],
      subTitle: map['subTitle'],
      price: map['price'],
      numberOfRooms: map['numberOfRooms'],
      bhk: map['bhk'],
      location: map['location'],
      city: map['city'],
      mainImage: map['mainImage'],
      images: map['images'] != null ? List<PropertyMedia>.from(map['images']?.map((x) => PropertyMedia.fromMap(x))) : null,
      type: map['type'],
      area: map['area'],
      areaUnit: map['areaUnit'],
      description: map['description'],
      createdDate: map['createdDate'],
      updatedDate: map['updatedDate'],
      builderPhoneNumber: map['builderPhoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyModel.fromJson(String source) => PropertyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PropertyModel(id: $id, title: $title, subTitle: $subTitle, price: $price, numberOfRooms: $numberOfRooms, bhk: $bhk, location: $location, city: $city, mainImage: $mainImage, images: $images, type: $type, area: $area, areaUnit: $areaUnit, description: $description, createdDate: $createdDate, updatedDate: $updatedDate, builderPhoneNumber: $builderPhoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is PropertyModel &&
      other.id == id &&
      other.title == title &&
      other.subTitle == subTitle &&
      other.price == price &&
      other.numberOfRooms == numberOfRooms &&
      other.bhk == bhk &&
      other.location == location &&
      other.city == city &&
      other.mainImage == mainImage &&
      listEquals(other.images, images) &&
      other.type == type &&
      other.area == area &&
      other.areaUnit == areaUnit &&
      other.description == description &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate &&
      other.builderPhoneNumber == builderPhoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      subTitle.hashCode ^
      price.hashCode ^
      numberOfRooms.hashCode ^
      bhk.hashCode ^
      location.hashCode ^
      city.hashCode ^
      mainImage.hashCode ^
      images.hashCode ^
      type.hashCode ^
      area.hashCode ^
      areaUnit.hashCode ^
      description.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode ^
      builderPhoneNumber.hashCode;
  }
}
