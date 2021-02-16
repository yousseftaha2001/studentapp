import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SolutionModel {
  final String studentName;
  final String priviteComment;
  final List<String> attachments;
  final String filesType;
  SolutionModel({
    this.studentName,
    this.priviteComment,
    this.attachments,
    this.filesType,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'notes': priviteComment,
      'hendItTime': Timestamp.now(),
      'attachments': attachments,
      'filesType':filesType,
    };
  }

  factory SolutionModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SolutionModel(
      studentName: map['studentName'],
      priviteComment: map['notes'],
      attachments: map['attachments'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SolutionModel.fromJson(String source) =>
      SolutionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SolutionModel(studentName: $studentName, notes: $priviteComment, attachments: $attachments)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SolutionModel &&
        o.studentName == studentName &&
        o.priviteComment == priviteComment &&
        o.attachments == attachments;
  }

  @override
  int get hashCode {
    return studentName.hashCode ^
        priviteComment.hashCode ^
        attachments.hashCode;
  }
}
