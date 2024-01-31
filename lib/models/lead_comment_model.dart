import 'dart:convert';

class LeadCommentModel {
  String? comment;
  String? userType;
  String? timeStamp;
  LeadCommentModel({
    this.comment,
    this.userType,
    this.timeStamp,
  });

  LeadCommentModel copyWith({
    String? comment,
    String? userType,
    String? timeStamp,
  }) {
    return LeadCommentModel(
      comment: comment ?? this.comment,
      userType: userType ?? this.userType,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'userType': userType,
      'timeStamp': timeStamp,
    };
  }

  factory LeadCommentModel.fromMap(Map<String, dynamic> map) {
    return LeadCommentModel(
      comment: map['comment'],
      userType: map['userType'],
      timeStamp: map['timeStamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadCommentModel.fromJson(String source) => LeadCommentModel.fromMap(json.decode(source));

  @override
  String toString() => 'LeadCommentModel(comment: $comment, userType: $userType, timeStamp: $timeStamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LeadCommentModel &&
      other.comment == comment &&
      other.userType == userType &&
      other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => comment.hashCode ^ userType.hashCode ^ timeStamp.hashCode;
}
