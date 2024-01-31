import 'dart:convert';

class MailModel {
  String? from;
  String? to;
  String? subject;
  String? html;
  MailModel({
    this.from,
    this.to,
    this.subject,
    this.html,
  });

  MailModel copyWith({
    String? from,
    String? to,
    String? subject,
    String? html,
  }) {
    return MailModel(
      from: from ?? this.from,
      to: to ?? this.to,
      subject: subject ?? this.subject,
      html: html ?? this.html,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(from != null){
      result.addAll({'from': from});
    }
    if(to != null){
      result.addAll({'to': to});
    }
    if(subject != null){
      result.addAll({'subject': subject});
    }
    if(html != null){
      result.addAll({'html': html});
    }
  
    return result;
  }

  factory MailModel.fromMap(Map<String, dynamic> map) {
    return MailModel(
      from: map['from'],
      to: map['to'],
      subject: map['subject'],
      html: map['html'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MailModel.fromJson(String source) => MailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MailModel(from: $from, to: $to, subject: $subject, html: $html)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MailModel &&
      other.from == from &&
      other.to == to &&
      other.subject == subject &&
      other.html == html;
  }

  @override
  int get hashCode {
    return from.hashCode ^
      to.hashCode ^
      subject.hashCode ^
      html.hashCode;
  }
}
